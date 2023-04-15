//
//  AccountDetailView.swift
//  Keys
//
//  Created by John Jakobsen on 7/24/22.
//

import Foundation
import UIKit

class AccountDetailView: UITableView {
    
    var _headerView: AccountTypeView
        
    init(viewModel: AccountDetailViewModel) {
        _headerView = AccountTypeView(image: viewModel.accountImage, text: viewModel.accountTypeName)
        super.init(frame: CGRect(), style: .plain)
        self.separatorStyle = .none
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
        _imageView = image != nil ? UIImageView(image: image!) : UIImageView()
        _imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        _imageView.widthAnchor.constraint(equalTo: _imageView.heightAnchor).isActive = true
        _textLabel = UILabel()
        _textLabel.text = text
        _textLabel.font = FontConstants.LabelTitle1
        
        super.init(frame: CGRect())
        self.axis = .horizontal
        self.alignment = .center
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(_imageView)
        self.addArrangedSubview(_textLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
