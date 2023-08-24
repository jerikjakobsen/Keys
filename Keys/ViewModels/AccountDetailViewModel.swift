//
//  AccountDetailViewModel.swift
//  Keys
//
//  Created by John Jakobsen on 7/24/22.
//

import Foundation
import UIKit
import XML

struct AccountDetailViewModel {
    var entry: EntryXML
    var accountImage: UIImage? = nil
    
    init(entry: EntryXML) {
        self.entry = entry
        if let accountImg = accountImage {
            self.accountImage = accountImg
        } else if let imageData = try? NetworkManager.shared?.getImageLocally(imageID: entry.iconID.value) {
            self.accountImage = UIImage(data: imageData)
        }
    }
}
