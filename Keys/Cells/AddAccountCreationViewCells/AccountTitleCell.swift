//
//  AccountTitleCell.swift
//  Keys
//
//  Created by John Jakobsen on 8/12/22.
//

import Foundation
import UIKit

protocol AccountTitleCellDelegate {
    func didChangeAccountTitle(_ accountTitle: String)
}

class AccountTitleCell: UITableViewCell, FieldValueProtocol, UITextFieldDelegate {
    
    let accountField: UITextField
    var delegate: AccountTitleCellDelegate? = nil
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        accountField = UITextField()
        accountField.placeholder = "Account"
        accountField.textAlignment = .center
        accountField.translatesAutoresizingMaskIntoConstraints = false
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.addSubview(accountField)
        let constraints = [
            accountField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            accountField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            accountField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            accountField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(constraints)
        
        accountField.addTarget(self, action: #selector(self.textFieldDidChange), for: .allEditingEvents)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func FieldValue() -> Field {
        return Field(fieldType: "Account", fieldValue: accountField.text ?? "")
    }
    
    @objc func textFieldDidChange() {
        guard let accountTitleText = self.accountField.text else {
            return
        }
        delegate?.didChangeAccountTitle(accountTitleText)
    }
    
}
