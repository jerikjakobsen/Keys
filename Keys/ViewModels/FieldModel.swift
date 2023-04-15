//
//  FieldModel.swift
//  Keys
//
//  Created by John Jakobsen on 8/5/22.
//

import Foundation

struct Field {
    let fieldType: String
    let fieldValue: String
    
    func toDict() -> [String:String] {
        return [fieldType: fieldValue]
    }
    
    func updateType(type: String) -> Field {
        return Field(fieldType: type, fieldValue: fieldValue)
    }
    
    func updateValue(value: String) -> Field {
        return Field(fieldType: fieldType, fieldValue: value)
    }
    
    init() {
        fieldType = "Username"
        fieldValue = ""
    }
    init(fieldType: String, fieldValue: String) {
        self.fieldType = fieldType
        self.fieldValue = fieldValue
    }
}
