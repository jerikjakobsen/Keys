//
//  AccountCellViewModel.swift
//  Keys
//
//  Created by John Jakobsen on 7/23/22.
//

import Foundation
import UIKit

struct AccountCellViewModel  {
    let username: String?
    let email: String?
    let accountImage: UIImage?
    let accountTypeName: String
    let hasUsername: Bool
    let hasEmail: Bool
    
    init(username: String? = nil, email: String? = nil, accountImage: UIImage? = nil, accountTypeName: String) {
        self.username = username
        self.email = email
        self.accountImage = accountImage
        self.accountTypeName = accountTypeName
        self.hasUsername = username != nil
        self.hasEmail = email != nil
    }
}
