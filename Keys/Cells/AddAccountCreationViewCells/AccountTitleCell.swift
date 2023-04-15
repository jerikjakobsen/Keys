//
//  AccountTitleCell.swift
//  Keys
//
//  Created by John Jakobsen on 8/12/22.
//

import Foundation
import UIKit

class AccountTitleCell: UITableViewCell, FieldValueProtocol {
    
    let accountField: UITextField
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        accountField = UITextField()
        accountField.placeholder = "Account"
        accountField.textAlignment = .center
        accountField.translatesAutoresizingMaskIntoConstraints = false
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(accountField)
        let constraints = [
            accountField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            accountField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            accountField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            accountField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func FieldValue() -> Field {
        return Field(fieldType: "Account", fieldValue: accountField.text ?? "")
    }
    
}
