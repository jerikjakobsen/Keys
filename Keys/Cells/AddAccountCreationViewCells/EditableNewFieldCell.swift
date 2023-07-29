//
//  EditableNewFieldCell.swift
//  Keys
//
//  Created by John Jakobsen on 8/5/22.
//

import Foundation
import UIKit

class EditableNewFieldCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, FieldValueProtocol {
    
    let typePickerOptions: [String] = ["Username", "Email", "Name","Description" , "Password", "Pin", "Recovery Email", "Phone Number", "Website"]
    let fieldTypePickerView: UIPickerView
    let fieldTextField: UITextField
    let fieldTextFieldUnderlineLayer: CALayer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        fieldTypePickerView = UIPickerView()
        fieldTypePickerView.translatesAutoresizingMaskIntoConstraints = false
        fieldTextField = UITextField()
        fieldTextField.translatesAutoresizingMaskIntoConstraints = false
        fieldTextField.placeholder = typePickerOptions[0]
        fieldTextField.backgroundColor = .clear
        fieldTextFieldUnderlineLayer = CALayer()
        fieldTextFieldUnderlineLayer.masksToBounds = true
        fieldTextFieldUnderlineLayer.backgroundColor = ColorConstants.GrayColor.cgColor
        fieldTextFieldUnderlineLayer.borderWidth = 0.0
        fieldTextField.borderStyle = .none
        fieldTextField.layer.addSublayer(fieldTextFieldUnderlineLayer)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(fieldTypePickerView)
        self.contentView.addSubview(fieldTextField)
        let constraints = [
            fieldTypePickerView.heightAnchor.constraint(equalToConstant: 80),
            fieldTypePickerView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.45),
            
            fieldTypePickerView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            fieldTypePickerView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            fieldTypePickerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            fieldTypePickerView.rightAnchor.constraint(equalTo: fieldTextField.leftAnchor, constant: -10),
            
            fieldTextField.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10),
            fieldTextField.centerYAnchor.constraint(equalTo: fieldTypePickerView.centerYAnchor),
            fieldTextField.topAnchor.constraint(greaterThanOrEqualTo: self.contentView.topAnchor, constant:  10),
            fieldTextField.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(constraints)
        self.fieldTypePickerView.delegate = self
        self.fieldTypePickerView.dataSource = self
        self.fieldTextField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        fieldTextFieldUnderlineLayer.frame = CGRect(x: 0.0, y: fieldTextField.bounds.maxY, width: fieldTextField.bounds.width, height: 1.0)
    }
    
    func FieldValue() -> Field {
        return Field(fieldType: typePickerOptions[self.fieldTypePickerView.selectedRow(inComponent: 0)], fieldValue: self.fieldTextField.text ?? "")
    }
}

extension EditableNewFieldCell {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typePickerOptions.count
    }
 
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let baseString = typePickerOptions[row]
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributedString = NSAttributedString(string: baseString, attributes: [.font: FontConstants.LabelRegular, .paragraphStyle: paragraphStyle])
        let label: UILabel = UILabel()
        label.numberOfLines = 0
        
        label.attributedText = attributedString
        return label
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.fieldTextField.placeholder = typePickerOptions[row]
    }
}

extension EditableNewFieldCell {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.fieldTextFieldUnderlineLayer.backgroundColor = ColorConstants.TextColor.cgColor
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.fieldTextFieldUnderlineLayer.backgroundColor = ColorConstants.GrayColor.cgColor
    }
}


