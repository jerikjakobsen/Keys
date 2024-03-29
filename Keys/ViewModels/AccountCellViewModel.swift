//
//  AccountCellViewModel.swift
//  Keys
//
//  Created by John Jakobsen on 7/23/22.
//

import Foundation
import UIKit
import XML

struct AccountCellViewModel  {
    let username: String?
    let email: String?
    let accountImage: UIImage?
    let accountTypeName: String
    let hasUsername: Bool
    let hasEmail: Bool
    let entry: EntryXML
    
    init(username: String? = nil, email: String? = nil, accountImage: UIImage? = nil, accountTypeName: String, entry: EntryXML) {
        self.username = username
        self.email = email
        self.accountImage = accountImage
        self.accountTypeName = accountTypeName
        self.hasUsername = username != nil
        self.hasEmail = email != nil
        self.entry = entry
    }
    
    init(entry: EntryXML) {
        self.init(username: entry.username, email: entry.email, accountTypeName: entry.name.value, entry: entry)
    }
}
