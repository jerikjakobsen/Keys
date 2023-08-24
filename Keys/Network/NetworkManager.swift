//
//  NetworkHandler.swift
//  Keys
//
//  Created by John Jakobsen on 8/4/23.
//

import Foundation
import Network
import KDBX
import Reachability

enum NetworkHandlerError: Error {
    case NoServerKey
    case NoServerBaseURL
    case UnableToCreateAuthCookie
    case CannotConstructURL
    case UnableToConvertResponseToHTTP
    case CouldNotFetchData
    case NoDomain
    case NoServerLastUpdated
    case UnableToConvertTimeStringToInt
    case CouldNotParseJSON
    case UnknownKDBXSyncState
    case CouldNotUploadKDBX
    case UnableToSync
    case NoEmailOrPassword
    case NoKDBXAvailable
    case NoImageAtPath
}

public var NSURLErrorConnectionFailureCodes: [Int] {
    [
        NSURLErrorBackgroundSessionInUseByAnotherProcess, /// Error Code: `-996`
        NSURLErrorCannotFindHost, /// Error Code: ` -1003`
        NSURLErrorCannotConnectToHost, /// Error Code: ` -1004`
        NSURLErrorNetworkConnectionLost, /// Error Code: ` -1005`
        NSURLErrorNotConnectedToInternet, /// Error Code: ` -1009`
        NSURLErrorSecureConnectionFailed /// Error Code: ` -1200`
    ]
}

extension Error {
    var isConnectionError: Bool {
        return NSURLErrorConnectionFailureCodes.contains(_code)
    }
}

class NetworkManager {
    
    enum DatabaseSyncStatus {
        case UploadNeeded
        case DownloadNeeded
        case InSync
        case NoLocalOrServerDatabase
        case Unknown
    }
    public static let shared: NetworkManager? = try? NetworkManager()
    
    private let session: URLSession
    private let baseURLString: String
    private let baseURL: URL
    var databaseSyncStatus: DatabaseSyncStatus
    
    private var _email: String? = nil
    private var _password: String? = nil
    
    init() throws {
        guard let server_key = Bundle.main.infoDictionary?["SERVER_KEY"] as? String else {
            throw NetworkHandlerError.NoServerKey
        }
        
        guard let baseURL = Bundle.main.infoDictionary?["SERVER_BASE_URL"] as? String else {
            throw NetworkHandlerError.NoServerBaseURL
        }
        
        guard let domain = Bundle.main.infoDictionary?["SERVER_DOMAIN"] as? String else {
            throw NetworkHandlerError.NoDomain
        }
        
        self.baseURLString = baseURL
        
        guard let url = URL(string: "\(self.baseURLString)/getKDBX") else {
            throw NetworkHandlerError.CannotConstructURL
        }
        
        self.baseURL = url
        
        self.session = URLSession(configuration: .default)
        self.session.configuration.waitsForConnectivity = true
        self.session.configuration.timeoutIntervalForRequest = 5
        self.session.configuration.timeoutIntervalForResource = 60*2
        
        let cookieProperties: [HTTPCookiePropertyKey: String] = [
            .name: "server_key",
            .value: server_key,
            .domain: domain,
            .path: "/",
            .originURL: baseURLString
        ]
        
        guard let serverAuthCookie: HTTPCookie = HTTPCookie(properties: cookieProperties) else {
            throw NetworkHandlerError.UnableToCreateAuthCookie
        }
        HTTPCookieStorage.shared.setCookie(serverAuthCookie)
        
        self.databaseSyncStatus = .Unknown
    }
    
    public func removeCredentials() throws {
        guard let baseURL = URL(string: self.baseURLString) else {
            throw NetworkHandlerError.CannotConstructURL
        }
        let cookies = HTTPCookieStorage.shared.cookies(for: baseURL)
        for cookie in cookies ?? [] {
            if (cookie.name == "connect.sid" ) {
                HTTPCookieStorage.shared.deleteCookie(cookie as HTTPCookie)
            }
        }
    }
    
    public func setCredentials(email: String, password: String) throws {
        self._email = email
        self._password = password
        guard let baseURL = URL(string: self.baseURLString) else {
            throw NetworkHandlerError.CannotConstructURL
        }
        let cookies = HTTPCookieStorage.shared.cookies(for: baseURL)
        for cookie in cookies ?? [] {
            if (cookie.name == "connect.sid" ) {
                HTTPCookieStorage.shared.deleteCookie(cookie as HTTPCookie)
            }
        }
    }
    
    private func usersKDBXFileURL() throws -> URL {
        guard let email = _email?.lowercased() else {
            throw NetworkHandlerError.NoEmailOrPassword
        }
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("\(email).kdbx")
    }
    
    private func userKDBXFIleExists() throws -> Bool {
        let usersFileURL = try usersKDBXFileURL()
        
        return FileManager.default.fileExists(atPath: usersFileURL.path)
    }
    
    private func createJSONRequest(endpoint: String, requestType: String, body: [String: String]) throws -> URLRequest {
        guard let url = URL(string: "\(self.baseURLString)\(endpoint)") else {
            throw NetworkHandlerError.CannotConstructURL
        }
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.httpMethod = requestType
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        guard let baseURL = URL(string: self.baseURLString) else {
            throw NetworkHandlerError.CannotConstructURL
        }
        if let cookies = HTTPCookieStorage.shared.cookies(for: baseURL) {
            let cookieHeaders = HTTPCookie.requestHeaderFields(with: cookies)
            request.allHTTPHeaderFields = cookieHeaders
        }
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    private func sendRequest(request: URLRequest) async throws -> (data: Data, httpresponse: HTTPURLResponse) {
        let (data, response) = try await self.session.data(for: request)
        guard let httpresponse = response as? HTTPURLResponse else {
            throw NetworkHandlerError.UnableToConvertResponseToHTTP
        }
        return (data, httpresponse)
    }
    
    private func convertDataToJSON(_ data: Data) throws -> [String: Any] {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            throw NetworkHandlerError.CouldNotParseJSON
        }
        return json
    }
    
    public func login(email: String, password: String) async throws -> (error: String?, kdbx: KDBX?) {
        
        let emailLowercase = email.lowercased()
        
        if let error = CredentialHelpers.verifyLoginCredentials(email: emailLowercase, password: password) {
            return (error, nil)
        }
        
        let body: [String: String] = ["email": emailLowercase, "password": password]
        let request = try createJSONRequest(endpoint: "/login", requestType: "POST", body: body)
        do {
            let httpResponse = (try await sendRequest(request: request)).httpresponse
            
            if (httpResponse.statusCode != 200 || httpResponse.statusCode == 404) {
                return ("Wrong Credentials", nil)
            }
            
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: httpResponse.allHeaderFields as! [String : String], for: self.baseURL)
            
            for cookie in cookies {
                HTTPCookieStorage.shared.setCookie(cookie)
            }
            
            self._email = email
            self._password = password
            guard let serverTimeUpdatedStr = httpResponse.value(forHTTPHeaderField: KeysUserDefaults.DBUpdatedAt) else {
                throw NetworkHandlerError.NoServerLastUpdated
            }
            
            guard let serverTimeUpdated = Int(serverTimeUpdatedStr) else {
                throw NetworkHandlerError.UnableToConvertTimeStringToInt
            }
            
            let localTimeUpdated = KeysUserDefaults.getLocalDBUpdatedAt(for: emailLowercase)
            
            if (localTimeUpdated == 0 && serverTimeUpdated == 0) {
                // Try to pull database from server
                // If no database exists, create a local database
                self.databaseSyncStatus = .NoLocalOrServerDatabase
            } else if (localTimeUpdated > serverTimeUpdated) {
                // Upload local database to server in background
                self.databaseSyncStatus = .UploadNeeded
            } else if (localTimeUpdated < serverTimeUpdated) {
                // Pull database to client
                // Once database is pulled return true for login
                self.databaseSyncStatus = .DownloadNeeded
            } else if (localTimeUpdated == serverTimeUpdated) {
                // Do nothing just let user login
                self.databaseSyncStatus = .InSync
            }
        } catch {
            let errMessage = error.isConnectionError ? "Could not connect to the Internet" : "Something went wrong"
            try self.setCredentials(email: email, password: password)
            if (try !self.userKDBXFIleExists()) {
                try self.removeCredentials()
                return ("\(errMessage)\nNo local database with those credentials", nil)
            }
            let fileHandle = try FileHandle(forReadingFrom: self.usersKDBXFileURL())
            defer { fileHandle.closeFile() }

            let fileData = fileHandle.readDataToEndOfFile()
            
            do {
                let kdbx = try await KDBX.fromEncryptedData(fileData, password: password)
                try self.setCredentials(email: email, password: password)
                return ("\(errMessage)\nLogging into local database", kdbx)
            } catch {
                return ("\(errMessage)\nNo local database with those credentials", nil)
            }
        }
        
        return (nil, nil)
    }
    
    public func createAccount(email: String, password: String) async throws -> String? {
        
        let body: [String: String] = ["email": email, "password": password]
        let request = try createJSONRequest(endpoint: "/createAccount", requestType: "POST", body: body)
        
        do {
            let (data, httpresponse) = try await sendRequest(request: request)
            let json = try convertDataToJSON(data)
            
            if (httpresponse.statusCode != 201) {
                if let message = json["message"] as? String {
                    return message
                } else {
                    return "Something went wrong"
                }
            }
            try self.setCredentials(email: email, password: password)
        } catch {
            let errMessage = error.isConnectionError ? "Could not connect to the Internet" : "Something went wrong"
            return errMessage
        }
        
        return nil
    }
    
    public func syncKDBX() async throws -> KDBX {
        
        guard let email = self._email, let password = _password else {
            throw NetworkHandlerError.NoEmailOrPassword
        }
        
        switch (self.databaseSyncStatus) {
        case .Unknown:
            // Login either failed or was never called
            throw NetworkHandlerError.UnknownKDBXSyncState
        case .DownloadNeeded:
            do {
                return try await downloadKDBX()
            } catch {
                if (try self.userKDBXFIleExists()) {
                    let fileHandle = try FileHandle(forReadingFrom: self.usersKDBXFileURL())
                    defer { fileHandle.closeFile() }
                    let fileData = fileHandle.readDataToEndOfFile()
                    return try await KDBX.fromEncryptedData(fileData, password: password)
                }
                throw NetworkHandlerError.NoKDBXAvailable
            }
        case .UploadNeeded:
            let fileHandle = try FileHandle(forReadingFrom: self.usersKDBXFileURL())
            defer { fileHandle.closeFile() }
            let fileData = fileHandle.readDataToEndOfFile()
            do {
                try await uploadKDBX(data: fileData)
                
                self.databaseSyncStatus = .InSync
            } catch {
                print(error)
            }
            return try await KDBX.fromEncryptedData(fileData, password: password)
        case .InSync:
            let fileHandle = try FileHandle(forReadingFrom: self.usersKDBXFileURL())
            defer { fileHandle.closeFile() }
            let fileData = fileHandle.readDataToEndOfFile()
            
            return try await KDBX.fromEncryptedData(fileData, password: password)
        case .NoLocalOrServerDatabase:
            return try KDBX(title: email)
        }
    }
    
    private func downloadKDBX() async throws -> KDBX {
        
        guard let email = self._email, let password = _password else {
            throw NetworkHandlerError.NoEmailOrPassword
        }
        
        guard let url = URL(string: "\(self.baseURLString)/getKDBX") else {
            throw NetworkHandlerError.CannotConstructURL
        }
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.httpMethod = "GET"
        guard let baseURL = URL(string: self.baseURLString) else {
            throw NetworkHandlerError.CannotConstructURL
        }
        if let cookies = HTTPCookieStorage.shared.cookies(for: baseURL) {
            let cookieHeaders = HTTPCookie.requestHeaderFields(with: cookies)
            request.allHTTPHeaderFields = cookieHeaders
        }
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        
        
        let (data, response) = try await self.session.data(for: request)
        
        guard let httpresponse = response as? HTTPURLResponse else {
            throw NetworkHandlerError.UnableToConvertResponseToHTTP
        }
        
        guard httpresponse.statusCode == 200 else {
            throw NetworkHandlerError.CouldNotFetchData
        }
        
        guard let serverTimeUpdatedStr = httpresponse.value(forHTTPHeaderField: KeysUserDefaults.DBUpdatedAt) else {
            throw NetworkHandlerError.NoServerLastUpdated
        }
        
        guard let serverTimeUpdated = Int(serverTimeUpdatedStr) else {
            throw NetworkHandlerError.UnableToConvertTimeStringToInt
        }
        
        try data.write(to: self.usersKDBXFileURL())
        
        KeysUserDefaults.updateDBUpdatedAt(for: email, at: serverTimeUpdated)
        
        return try await KDBX.fromEncryptedData(data, password: password)
    }
    
    private func uploadKDBX(data: Data) async throws {
        
        guard let email = self._email else {
            throw NetworkHandlerError.NoEmailOrPassword
        }
        
        guard let url = URL(string: "\(self.baseURLString)/updateKDBX") else {
            throw NetworkHandlerError.CannotConstructURL
        }
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.httpMethod = "POST"
        guard let baseURL = URL(string: self.baseURLString) else {
            throw NetworkHandlerError.CannotConstructURL
        }
        if let cookies = HTTPCookieStorage.shared.cookies(for: baseURL) {
            let cookieHeaders = HTTPCookie.requestHeaderFields(with: cookies)
            request.allHTTPHeaderFields = cookieHeaders
        }
        
       let timeNowString = KeysUserDefaults.updateDBUpdatedAt(for: email, at: Date.now)
        
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        request.setValue(timeNowString, forHTTPHeaderField: KeysUserDefaults.DBUpdatedAt)
        
        let (_, response) = try await self.session.upload(for: request, from: data)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkHandlerError.UnableToConvertResponseToHTTP
        }
        
        guard httpResponse.statusCode == 200 else {
            throw NetworkHandlerError.CouldNotUploadKDBX
        }
    }
    
    public func saveKDBX(_ kdbx: KDBX) async throws {
        guard let password = _password else {
            throw NetworkHandlerError.NoEmailOrPassword
        }
        let encryptedData = try await kdbx.encryptToData(password: password)
        
        try encryptedData.write(to: self.usersKDBXFileURL())
        
        try await uploadKDBX(data: encryptedData)
    }
    
    public func saveImageLocally(imageData: Data, imageID: String) throws {
        // Image should be in png format
        guard let email = _email else {
            throw NetworkHandlerError.NoEmailOrPassword
        }
        let imageName = "\(email)-\(imageID).png"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        if !FileManager.default.fileExists(atPath: documentsDirectory.appendingPathComponent("Images").path) {
            try FileManager.default.createDirectory(at: documentsDirectory.appendingPathComponent("Images"), withIntermediateDirectories: false)
        }
        let imageFileURL = documentsDirectory.appendingPathComponent("Images").appendingPathComponent(imageName)
        try imageData.write(to: imageFileURL)
    }
    
    public func getImageLocally(imageID: String) throws -> Data {
        guard let email = _email else {
            throw NetworkHandlerError.NoEmailOrPassword
        }
        let imageName = "\(email)-\(imageID).png"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imageFileURL = documentsDirectory.appendingPathComponent("Images").appendingPathComponent(imageName)
        guard FileManager.default.fileExists(atPath: imageFileURL.path) else {
            throw NetworkHandlerError.NoImageAtPath
        }
        
        let fileHandle = try FileHandle(forReadingFrom: imageFileURL)
        defer { fileHandle.closeFile() }

        let fileData = fileHandle.readDataToEndOfFile()
        return fileData
    }
}
