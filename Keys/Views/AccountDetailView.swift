//
//  AccountDetailView.swift
//  Keys
//
//  Created by John Jakobsen on 7/24/22.
//

import Foundation
import UIKit
import XML

class AccountDetailView: UITableView {
    
    var _headerView: AccountTypeView
    var _viewModel: AccountDetailViewModel
        
    init(viewModel: AccountDetailViewModel) {
        _headerView = AccountTypeView(image: viewModel.accountImage, text: viewModel.entry.name.value)
        self._viewModel = viewModel
        super.init(frame: CGRect(), style: .plain)
        self.separatorStyle = .singleLine
        self.translatesAutoresizingMaskIntoConstraints = false
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = 200
        self.register(FieldInfoCell.self, forCellReuseIdentifier: "FieldInfoCell")
        let headerViewSize: CGSize = _headerView.sizeThatFits(self.contentSize)
        _headerView.frame = CGRect(x: 0, y: 0, width: headerViewSize.width, height: headerViewSize.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class AccountTypeView: UIStackView {
    
    var _imageView: UIImageView
    var _textLabel: UILabel
    
    init(image: UIImage?, text: String) {
        if let img = image {
            _imageView = UIImageView(image: img)
            _imageView.round()
        } else {
            _imageView = UIImageView(image: UIImage(named: "lock"))
        }
        _imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        _imageView.contentMode = .scaleAspectFit
        _imageView.translatesAutoresizingMaskIntoConstraints = false 
        _imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        _textLabel = UILabel()
        _textLabel.text = text
        _textLabel.font = FontConstants.LabelTitle1
        
        super.init(frame: CGRect())
        self.spacing = 10
        self.axis = .horizontal
        self.alignment = .center
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(_imageView)
        self.addArrangedSubview(_textLabel)
        self.isLayoutMarginsRelativeArrangement = true
        self.directionalLayoutMargins = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
