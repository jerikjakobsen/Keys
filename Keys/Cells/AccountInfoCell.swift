//
//  AccountInfoCellView.swift
//  Keys
//
//  Created by John Jakobsen on 7/23/22.
//

import Foundation
import UIKit

class AccountInfoCell: UITableViewCell {
    
    var _viewModel: AccountCellViewModel
    
    private var _detailContainerView: AccountDetailsView
    private var _accountTypeLabel: UILabel
    private var _accountImageView: UIImageView
    private var _toDetailImageView: UIImageView
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) not implemented")
    }
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, viewModel: AccountCellViewModel) {
        
        _viewModel = viewModel
        
        _detailContainerView = AccountDetailsView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), viewModel: viewModel)
        
        _accountTypeLabel = UILabel()
        _accountTypeLabel.numberOfLines = 0
        _accountTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        _accountTypeLabel.font = FontConstants.LabelTitle2
        _accountTypeLabel.text = viewModel.accountTypeName
        if let img = viewModel.accountImage {
            _accountImageView = UIImageView(image: img)
            _accountImageView.round()
        } else {
            _accountImageView = UIImageView(image: UIImage(named: "lock"))
        }
        _accountImageView.contentMode = .scaleAspectFit
        _accountImageView.translatesAutoresizingMaskIntoConstraints = false
        
        _toDetailImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        _toDetailImageView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(_accountTypeLabel)
        self.contentView.addSubview(_accountImageView)
        self.contentView.addSubview(_detailContainerView)
        self.contentView.addSubview(_toDetailImageView)
        self.selectionStyle = .none
        self.autolayoutSubviews()
    }
    
    func setWithViewModel(viewModel: AccountCellViewModel) {
        _accountTypeLabel.text = viewModel.accountTypeName
        _accountImageView.image = viewModel.accountImage
        _detailContainerView.setDetailContainerView(viewModel: viewModel)
    }
    

    
    private func autolayoutSubviews() {
        let accountTypeLabelConstraints = [
            _accountTypeLabel.centerYAnchor.constraint(equalTo: _accountImageView.centerYAnchor),
            _accountTypeLabel.leftAnchor.constraint(equalTo: _accountImageView.rightAnchor, constant: 10),
            _accountTypeLabel.rightAnchor.constraint(lessThanOrEqualTo: _toDetailImageView.leftAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(accountTypeLabelConstraints)
        
        let accountTypeImageViewConstraints = [
            _accountImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10),
            _accountImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            _accountImageView.heightAnchor.constraint(equalToConstant: 50),
            _accountImageView.widthAnchor.constraint(equalTo: _accountImageView.heightAnchor)
        ]
        NSLayoutConstraint.activate(accountTypeImageViewConstraints)
        
        let detailContainerViewConstraints = [
            _detailContainerView.leftAnchor.constraint(equalTo: _accountTypeLabel.leftAnchor),
            _detailContainerView.rightAnchor.constraint(lessThanOrEqualTo: self.contentView.rightAnchor, constant: 10),
            _detailContainerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            _detailContainerView.topAnchor.constraint(equalTo: _accountTypeLabel.bottomAnchor, constant: 10)
        ]
        NSLayoutConstraint.activate(detailContainerViewConstraints)
        
        let toDetailImageViewConstraints = [
            _toDetailImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10),
            _toDetailImageView.centerYAnchor.constraint(equalTo: _accountImageView.centerYAnchor),
        ]
        NSLayoutConstraint.activate(toDetailImageViewConstraints)
    }
    
    func didSelectCell() {
        let previousTintColor: UIColor = self._toDetailImageView.tintColor
        UIView.animate(withDuration: 0.25) {
            self._toDetailImageView.tintColor = .label
        } completion: { completed in
            UIView.animate(withDuration: 0.25) {
                self._toDetailImageView.tintColor = previousTintColor
            } completion: { completed in
                completed
            }

        }

    }
}

class AccountDetailsView: UIStackView {
    
    var _usernameTextView: UITextView
    var _emailTextView: UITextView
    
    override init(frame: CGRect) {
        _usernameTextView = UITextView()
        _emailTextView = UITextView()
        super.init(frame: frame)
    }
    
    init(frame: CGRect, viewModel: AccountCellViewModel) {
        _usernameTextView = UITextView()
        _usernameTextView.isScrollEnabled = false
        _usernameTextView.isEditable = false
        _usernameTextView.backgroundColor = ColorConstants.GrayColor
        _usernameTextView.layer.cornerRadius = 11
        _usernameTextView.textContainerInset = .init(top: 3, left: 3, bottom: 3, right: 3)
        _usernameTextView.isUserInteractionEnabled = false
        
        _emailTextView = UITextView()
        _emailTextView.isScrollEnabled = false
        _emailTextView.isEditable = false
        _emailTextView.backgroundColor = ColorConstants.GrayColor
        _emailTextView.layer.cornerRadius = 11
        _emailTextView.textContainerInset = .init(top: 3, left: 3, bottom: 3, right: 3)
        _emailTextView.isUserInteractionEnabled = false

        super.init(frame: frame)
        self.axis = .vertical
        self.spacing = 10
        self.translatesAutoresizingMaskIntoConstraints = false
        self.alignment = .leading
        self.spacing = UIStackView.spacingUseSystem
        self.isLayoutMarginsRelativeArrangement = true
        self.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 50)
        
        self.setDetailContainerView(viewModel: viewModel)
        self.addArrangedSubview(_usernameTextView)
        self.addArrangedSubview(_emailTextView)
    }
    
    func setDetailContainerView(viewModel: AccountCellViewModel) {
        self._emailTextView.isHidden = !viewModel.hasEmail
        if (viewModel.hasEmail) {
            _emailTextView.attributedText = makeFieldString(fieldName: "Email", fieldContent: viewModel.email!)
        }
        
        self._usernameTextView.isHidden = !viewModel.hasUsername
        if (viewModel.hasUsername) {
            _usernameTextView.attributedText = makeFieldString(fieldName: "Username", fieldContent: viewModel.username!)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
