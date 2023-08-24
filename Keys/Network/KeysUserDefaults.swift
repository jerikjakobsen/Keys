//
//  UserDefaults.swift
//  Keys
//
//  Created by John Jakobsen on 8/7/23.
//

import Foundation

struct KeysUserDefaults {
    static let DBUpdatedAt = "dbUpdatedAt"
    
    static func updateDBUpdatedAt(for email: String, at date: Date) -> String {
        let timeNow = Int(date.timeIntervalSince1970)
        
        UserDefaults.standard.setValue(timeNow, forKey: "\(email.lowercased())-\(KeysUserDefaults.DBUpdatedAt)")
        return String(timeNow)
    }
    
    static func updateDBUpdatedAt(for email: String, at dateAsInt: Int) {
        UserDefaults.standard.setValue(dateAsInt, forKey: "\(email.lowercased())-\(KeysUserDefaults.DBUpdatedAt)")
    }
    
    static func getLocalDBUpdatedAt(for email: String) -> Int {
        return UserDefaults.standard.integer(forKey: "\(email)-\(KeysUserDefaults.DBUpdatedAt)")
    }
}
