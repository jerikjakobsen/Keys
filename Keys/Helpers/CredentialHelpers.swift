//
//  CredentialHelpers.swift
//  Keys
//
//  Created by John Jakobsen on 8/6/23.
//

import Foundation

public class CredentialHelpers {
    
    private static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static public func verifyCreationCredentials(email: String, password: String, confirmPassword: String) -> String? {
        if (!isValidEmail(email)) {
            return "Not a valid email"
        }
        
        if (password.count < 6) {
            return "Password must be more than 6 characters"
        }
        
        if (password != confirmPassword) {
            return "Password and Confirm Password do not match"
        }
        
        return nil
    }
    
    static public func verifyLoginCredentials(email: String, password: String) -> String? {
        if (email.count == 0 || password.count == 0) {
            return "Email or Password is blank"
        }
        
        if (!isValidEmail(email)) {
            return "Not a valid email"
        }
        
        return nil
    }
}
