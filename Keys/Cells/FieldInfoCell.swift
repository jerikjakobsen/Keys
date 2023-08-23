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
    
    enum FieldValueType {
        case Password
        case URL
        case Unknown
    }
    
    var _fieldKeyLabel: UILabel
    var _fieldValueLabel: UILabel
    var _buttonsStackView: UIStackView
    var _viewModel: FieldInfoCellViewModel? = nil
    var _valueShowing: Bool
    var _fieldValueType: FieldValueType = .Unknown
    var _delegate: FieldInfoCellDelegate?
    let _showButtonImage = UIImage(named: "eye" )?.withTintColor(.gray)
    let _dontShowButtonImage = UIImage(named: "eye.slash")?.withTintColor(.gray)
    let _copyButton: UIButton
    let _showValueButton: UIButton
    let _urlLinkButton: UIButton
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        //TODO: Convert from fieldTextview to fieldkey and fieldlabel
        //TODO: Seperate fieldview on password feed view and detailview
        _fieldKeyLabel = .init()
        _fieldKeyLabel.numberOfLines = 0
        _fieldKeyLabel.translatesAutoresizingMaskIntoConstraints = false
        _fieldKeyLabel.font = FontConstants.LabelMediumBold
        
        _fieldValueLabel = .init()
        _fieldValueLabel.numberOfLines = 0
        _fieldValueLabel.translatesAutoresizingMaskIntoConstraints = false
        _fieldValueLabel.font = FontConstants.LabelMedium
        
        _buttonsStackView = UIStackView()
        _buttonsStackView.axis = .horizontal
        _buttonsStackView.spacing = 10
        _buttonsStackView.translatesAutoresizingMaskIntoConstraints = false 
        
        _copyButton = UIButton()
        _copyButton.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        _copyButton.setImage(UIImage(systemName: "doc.on.doc.fill"), for: .selected)
        _copyButton.translatesAutoresizingMaskIntoConstraints = false
        
        _showValueButton = UIButton()
        _showValueButton.setImage(_dontShowButtonImage, for: .normal)
        _showValueButton.translatesAutoresizingMaskIntoConstraints = false
        
        _urlLinkButton = UIButton()
        _urlLinkButton.setImage(UIImage(named: "link"), for: .normal)
        _urlLinkButton.translatesAutoresizingMaskIntoConstraints = false

        _valueShowing = true
        
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        _copyButton.addTarget(self, action: #selector(copyText), for: .touchUpInside)
        _showValueButton.addTarget(self, action: #selector(_togglePasswordVisibility), for: .touchUpInside)
        _urlLinkButton.addTarget(self, action: #selector(openURL), for: .touchUpInside)
        self.selectionStyle = .none
        self.contentView.addSubview(_fieldKeyLabel)
        self.contentView.addSubview(_fieldValueLabel)
        self.contentView.addSubview(_buttonsStackView)
        
        autolayoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func autolayoutSubviews() {
        let keyLabelConstraints = [
            _fieldKeyLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            _fieldKeyLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            _fieldKeyLabel.rightAnchor.constraint(lessThanOrEqualTo: _buttonsStackView.leftAnchor, constant: -10),
            _fieldKeyLabel.bottomAnchor.constraint(equalTo: _fieldValueLabel.topAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(keyLabelConstraints)
        
        let valueLabelConstraints = [
            _fieldValueLabel.leftAnchor.constraint(equalTo: _fieldKeyLabel.leftAnchor, constant: 10),
            _fieldValueLabel.rightAnchor.constraint(lessThanOrEqualTo: _buttonsStackView.leftAnchor, constant: -10),
            _fieldValueLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(valueLabelConstraints)
        
        let buttonStackConstraints = [
            _buttonsStackView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 10),
            _buttonsStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            _buttonsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(buttonStackConstraints)
    }
    
    func setFieldInfoCell(viewModel: FieldInfoCellViewModel) {
        self._viewModel = viewModel
        _valueShowing = viewModel.keyVal.key.value != "Password"
        self._fieldKeyLabel.text = viewModel.keyVal.key.value
        self._fieldValueLabel.text = viewModel.keyVal.value.value
        switch viewModel.keyVal.key.value {
        case "Password":
            self._hideValue()
            // Add eye button
            if (self._fieldValueType != .Password) {
                self._fieldValueType = .Password
                self._buttonsStackView.removeAllSubviews()
                
                self._hideValue()
                
                self._buttonsStackView.addArrangedSubview(self._showValueButton)
                self._buttonsStackView.addArrangedSubview(self._copyButton)
            }
            break
        case "URL":
            if (self._fieldValueType != .URL) {
                self._fieldValueType = .URL
                self._buttonsStackView.removeAllSubviews()
                
                self._buttonsStackView.addArrangedSubview(self._urlLinkButton)
                self._buttonsStackView.addArrangedSubview(self._copyButton)
            }
            break
        default:
            self._fieldValueType = .Unknown
            self._buttonsStackView.removeAllSubviews()
            
            self._buttonsStackView.addArrangedSubview(self._copyButton)
        }
    }
    
    private func _hideValue() {
        if let vm  = _viewModel {
            self._fieldValueLabel.text = String(repeating: "\u{2022}", count: vm.keyVal.value.value.count)
            self._showValueButton.setImage(self._dontShowButtonImage, for: .normal)
        }
    }
    
    private func _showValue() {
        if let vm = _viewModel {
            self._fieldValueLabel.text = vm.keyVal.value.value
            self._showValueButton.setImage(self._showButtonImage, for: .normal)
        }
    }
    
    @objc private func _togglePasswordVisibility() {
        _valueShowing = !_valueShowing
        _valueShowing ? self._showValue() : self._hideValue()
        
    }
    
    @objc func copyText() {
        if let vm = _viewModel {
            UIPasteboard.general.string = vm.keyVal.value.value
            if _delegate != nil{
                _delegate?.didCopyField(fieldInfoCell: self, copiedText: vm.keyVal.value.value)
            }
        }
    }
    
    @objc func openURL() {
        if let vm = _viewModel, let url = URL(string: vm.keyVal.value.value) {
            UIApplication.shared.open(url)
        }
    }
}
