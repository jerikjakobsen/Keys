//
//  UnderlinedTextField.swift
//  Keys
//
//  Created by John Jakobsen on 7/28/23.
//

import Foundation
import UIKit

class UnderlinedTextField: UITextField, UITextFieldDelegate {
    
    let fieldTextFieldUnderlineLayer: CALayer
    
    override init(frame: CGRect) {
        self.fieldTextFieldUnderlineLayer = CALayer()
        super.init(frame: frame)
    }
    
    convenience init(placeholder: String = "") {
        self.init(frame: CGRect())
        self.font = FontConstants.LabelRegular
        self.translatesAutoresizingMaskIntoConstraints = false
        self.placeholder = placeholder
        self.backgroundColor = .clear
        fieldTextFieldUnderlineLayer.masksToBounds = true
        fieldTextFieldUnderlineLayer.backgroundColor = ColorConstants.GrayColor.cgColor
        fieldTextFieldUnderlineLayer.borderWidth = 0.0
        self.borderStyle = .none
        self.layer.addSublayer(fieldTextFieldUnderlineLayer)
        self.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        fieldTextFieldUnderlineLayer.frame = CGRect(x: 0.0, y: self.bounds.maxY, width: self.bounds.width, height: 1.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.fieldTextFieldUnderlineLayer.backgroundColor = ColorConstants.TextColor.cgColor
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.fieldTextFieldUnderlineLayer.backgroundColor = ColorConstants.GrayColor.cgColor
    }
    
}
