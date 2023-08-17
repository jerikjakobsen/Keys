//
//  CellHelpers.swift
//  Keys
//
//  Created by John Jakobsen on 7/24/22.
//

import Foundation

func makeFieldString(fieldName: String, fieldContent: String) -> NSAttributedString {
    let fieldText: NSMutableAttributedString = NSMutableAttributedString(string: "\(fieldName)\n\(fieldContent)", attributes: [NSAttributedString.Key.font: FontConstants.LabelRegular, NSAttributedString.Key.foregroundColor: ColorConstants.TextColor])
    let fieldNameRange: NSRange = (fieldText.string as NSString).range(of: fieldName)
    fieldText.setAttributes([NSAttributedString.Key.font: FontConstants.LabelEmphasized, NSAttributedString.Key.foregroundColor: ColorConstants.TextColor], range: fieldNameRange)
    return fieldText
}
