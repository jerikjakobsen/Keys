//
//  AccountDetailViewModel.swift
//  Keys
//
//  Created by John Jakobsen on 7/24/22.
//

import Foundation
import UIKit

struct AccountDetailViewModel {
    var accountImage: UIImage?
    var accountTypeName: String
    var AccountInfo: [FieldInfoCellViewModel]
    var lastUpdated: Date
    var createdAt: Date
}
