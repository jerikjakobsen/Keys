//
//  EditableNewFieldCell.swift
//  Keys
//
//  Created by John Jakobsen on 8/5/22.
//

import Foundation
import UIKit
import XML

class EditableNewFieldCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, FieldValueProtocol {
    
    var KeyVal: KeyValXML? = nil
    
    let typePickerOptions: [String] = ["Username", "Email", "Password", "Description", "Pin", "Recovery Email", "Phone Number", "URL", "Other"]
    let fieldTypePickerView: UIPickerView
    let fieldTextField: UnderlinedTextField
    let otherFieldTitleTextField: UnderlinedTextField
    var nonOtherConstraints: [NSLayoutConstraint] = []
    var otherConstraints: [NSLayoutConstraint] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        fieldTypePickerView = UIPickerView()
        fieldTypePickerView.translatesAutoresizingMaskIntoConstraints = false
        
        fieldTextField = UnderlinedTextField(placeholder: "Username")
        otherFieldTitleTextField = UnderlinedTextField(placeholder: "Name")
        otherFieldTitleTextField.isHidden = true
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(otherFieldTitleTextField)
        self.contentView.addSubview(fieldTypePickerView)
        self.contentView.addSubview(fieldTextField)
        nonOtherConstraints = [
            fieldTypePickerView.heightAnchor.constraint(equalToConstant: 80),
            fieldTypePickerView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.45),
            
            fieldTypePickerView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            fieldTypePickerView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            fieldTypePickerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            fieldTypePickerView.rightAnchor.constraint(equalTo: fieldTextField.leftAnchor, constant: -10),
            
            fieldTextField.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10),
            fieldTextField.centerYAnchor.constraint(equalTo: fieldTypePickerView.centerYAnchor),
            fieldTextField.topAnchor.constraint(greaterThanOrEqualTo: self.contentView.topAnchor, constant:  10),
            fieldTextField.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor, constant: -10),
            
            otherFieldTitleTextField.leftAnchor.constraint(equalTo: fieldTextField.leftAnchor),
            otherFieldTitleTextField.rightAnchor.constraint(equalTo: fieldTextField.rightAnchor),
            otherFieldTitleTextField.topAnchor.constraint(equalTo: fieldTextField.topAnchor),
            otherFieldTitleTextField.bottomAnchor.constraint(equalTo: fieldTextField.bottomAnchor)
        ]
        NSLayoutConstraint.activate(nonOtherConstraints)
        
        otherConstraints = [
            fieldTypePickerView.heightAnchor.constraint(equalToConstant: 80),
            fieldTypePickerView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.45),
            
            fieldTypePickerView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            fieldTypePickerView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            fieldTypePickerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            fieldTypePickerView.rightAnchor.constraint(equalTo: fieldTextField.leftAnchor, constant: -10),
            
            otherFieldTitleTextField.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10),
            otherFieldTitleTextField.bottomAnchor.constraint(equalTo: fieldTypePickerView.centerYAnchor, constant: -10),
            otherFieldTitleTextField.topAnchor.constraint(greaterThanOrEqualTo: self.contentView.topAnchor, constant:  10),
            
            fieldTextField.leftAnchor.constraint(equalTo: otherFieldTitleTextField.leftAnchor),
            fieldTextField.rightAnchor.constraint(equalTo: otherFieldTitleTextField.rightAnchor),
            fieldTextField.topAnchor.constraint(equalTo: otherFieldTitleTextField.bottomAnchor, constant: 20),
            fieldTextField.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor, constant: -10)
        ]
        self.fieldTypePickerView.delegate = self
        self.fieldTypePickerView.dataSource = self
        self.fieldTextField.delegate = self
        self.fieldTextField.addTarget(self, action: #selector(self.textFieldTextChanged), for: .allEditingEvents)
        self.otherFieldTitleTextField.addTarget(self, action: #selector(self.otherTextFieldTextChanged), for: .allEditingEvents)
    }
    
    func setKeyVal(_ kv: KeyValXML) {
        self.KeyVal = kv
        if let row = getMatchingFieldValueRow(kv.key.value) {
            self.fieldTypePickerView.selectRow(row, inComponent: 0, animated: false)
        } else {
            NSLayoutConstraint.deactivate(self.otherConstraints)
            NSLayoutConstraint.activate(self.nonOtherConstraints)
            self.contentView.layoutIfNeeded()
            self.fieldTypePickerView.selectRow(self.typePickerOptions.count-1, inComponent: 0, animated: false)
            self.otherFieldTitleTextField.text = kv.key.value
        }
        self.fieldTextField.text = kv.value.value
    }
    
    func getMatchingFieldValueRow(_ val: String) -> Int? {
        for (i, x) in self.typePickerOptions.enumerated() {
            if (x == val) {
                return i
            }
        }
        return nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func FieldValue() -> Field {
        return Field(fieldType: typePickerOptions[self.fieldTypePickerView.selectedRow(inComponent: 0)], fieldValue: self.fieldTextField.text ?? "")
    }
    @objc func textFieldTextChanged() {
        if let text = self.fieldTextField.text {
            self.KeyVal?.value.value = text
        }
    }
    @objc func otherTextFieldTextChanged() {
        if let text = self.otherFieldTitleTextField.text {
            self.KeyVal?.key.value = text
        }
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
        if (typePickerOptions[row] == "Other") {
            self.fieldTextField.placeholder = "Value"
            self.KeyVal?.key.value = self.otherFieldTitleTextField.text ?? ""
            self.contentView.layoutIfNeeded()
            UIView.animate(withDuration: 0.5) {
                self.otherFieldTitleTextField.isHidden = false
                NSLayoutConstraint.deactivate(self.nonOtherConstraints)
                NSLayoutConstraint.activate(self.otherConstraints)
                self.contentView.layoutIfNeeded()
            }
        } else {
            if (!self.otherFieldTitleTextField.isHidden) {
                self.contentView.layoutIfNeeded()
                UIView.animate(withDuration: 0.5) {
                    self.otherFieldTitleTextField.isHidden = true
                    NSLayoutConstraint.deactivate(self.otherConstraints)
                    NSLayoutConstraint.activate(self.nonOtherConstraints)
                    self.contentView.layoutIfNeeded()
                }
            }
            self.fieldTextField.placeholder = typePickerOptions[row]
            self.KeyVal?.key.value = typePickerOptions[row]
        }
    }
}


