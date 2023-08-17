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
    
    init(entry: EntryXML) {
        self.entry = entry
    }
}
