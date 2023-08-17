//
//  FieldInfoCellViewModel.swift
//  Keys
//
//  Created by John Jakobsen on 7/24/22.
//

import Foundation
import XML

struct FieldInfoCellViewModel {
    var keyVal: KeyValXML
    
    init(keyval: KeyValXML) {
        self.keyVal = keyval
    }
}
