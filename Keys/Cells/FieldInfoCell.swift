//
//  FieldInfoCell.swift
//  Keys
//
//  Created by John Jakobsen on 7/24/22.
//

import Foundation
import UIKit
import XML

protocol FieldInfoCellDelegate {
    func didCopyField(fieldInfoCell: FieldInfoCell, copiedText: String)
}

class FieldInfoCell: UITableViewCell {
    
    var _fieldTextView: UITextView
    var _copyButton: UIButton
    var _viewModel: FieldInfoCellViewModel
    var _passwordShowing: Bool
    var _delegate: FieldInfoCellDelegate?
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, viewModel: FieldInfoCellViewModel) {
        _viewModel = viewModel
        _fieldTextView = UITextView()
        _fieldTextView.isScrollEnabled = false
        _fieldTextView.isEditable = false
        _fieldTextView.isUserInteractionEnabled = false
        _fieldTextView.backgroundColor = ColorConstants.GrayColor
        _fieldTextView.layer.cornerRadius = 11
        _fieldTextView.textContainerInset = .init(top: 3, left: 3, bottom: 3, right: 3)
        _fieldTextView.translatesAutoresizingMaskIntoConstraints = false
        
        _copyButton = UIButton()
        _copyButton.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        _copyButton.setImage(UIImage(systemName: "doc.on.doc.fill"), for: .selected)
        _copyButton.translatesAutoresizingMaskIntoConstraints = false
        
        _passwordShowing = viewModel.keyVal.key.value != "Password"
        
        super.init(style: .default, reuseIdentifier: "FieldInfoCell")
        _copyButton.addTarget(self, action: #selector(copyText), for: .touchUpInside)
        self.selectionStyle = .none

        self.contentView.addSubview(_fieldTextView)
        self.contentView.addSubview(_copyButton)
        autolayoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func autolayoutSubviews() {
        let fieldLabelConstraints = [
            _fieldTextView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10),
            _fieldTextView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            _fieldTextView.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor, constant: -10),
            _fieldTextView.rightAnchor.constraint(lessThanOrEqualTo: self._copyButton.leftAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(fieldLabelConstraints)
        
        let copyButtonConstraints = [
            _copyButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10),
            _copyButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            _copyButton.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(copyButtonConstraints)
    }
    
    func setFieldInfoCell(viewModel: FieldInfoCellViewModel) {
        self._viewModel = viewModel
        _viewModel.keyVal.key.value == "Password" ? self._hidePassword() : self._showPassword()
        _passwordShowing = viewModel.keyVal.key.value == "Password"
        // self._copyButton.isHidden = !viewModel.isCopyable
    }
    
    func didSelectCell() {
        if (_viewModel.keyVal.key.value == "Password") {
            self._togglePasswordVisibility()
        }
    }
    
    private func _hidePassword() {
        self._fieldTextView.attributedText = makeFieldString(fieldName: _viewModel.keyVal.key.value, fieldContent: String(repeating: "\u{2022}", count: _viewModel.keyVal.value.value.count))
    }
    
    private func _showPassword() {
        self._fieldTextView.attributedText = makeFieldString(fieldName: _viewModel.keyVal.key.value, fieldContent: _viewModel.keyVal.value.value)
    }
    
    private func _togglePasswordVisibility() {
        _passwordShowing = !_passwordShowing
        _passwordShowing ? self._showPassword() : self._hidePassword()
    }
    
    @objc func copyText() {
        UIPasteboard.general.string = _viewModel.keyVal.value.value
        if _delegate != nil{
            _delegate!.didCopyField(fieldInfoCell: self, copiedText: _viewModel.keyVal.value.value)
        }
        
    }
}
