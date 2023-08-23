//
//  AccountImageSelectorCell.swift
//  Keys
//
//  Created by John Jakobsen on 8/12/22.
//

import Foundation
import UIKit

protocol AccountImageSelectorCellProtocol {
    func didTapUpload()
}

class AccountImageSelectorCell: UITableViewCell {
    
    let AccountImageLabel: UILabel
    let SearchButton: UIButton
    let UploadButton: UIButton
    let uploadedImageView: UIImageView = UIImageView(image: UIImage(systemName: "photo"))
    var delegate: AccountImageSelectorCellProtocol?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        uploadedImageView.translatesAutoresizingMaskIntoConstraints = false
        AccountImageLabel = UILabel()
        AccountImageLabel.text = "Account Image"
        AccountImageLabel.translatesAutoresizingMaskIntoConstraints = false
        AccountImageLabel.font = FontConstants.LabelMedium
        
        let config = UIImage.SymbolConfiguration(pointSize: 20)

        SearchButton = UIButton()
        let searchImage = UIImage(systemName: "magnifyingglass", withConfiguration: config)
        SearchButton .setImage(searchImage, for: .normal)
        SearchButton.translatesAutoresizingMaskIntoConstraints = false
        
        UploadButton = UIButton()
        let uploadImage = UIImage(systemName: "square.and.arrow.up", withConfiguration: config)
        UploadButton.setImage(uploadImage, for: .normal)
        UploadButton.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.contentView.addSubview(AccountImageLabel)
        self.contentView.addSubview(SearchButton)
        self.contentView.addSubview(UploadButton)
        self.contentView.addSubview(uploadedImageView)
        UploadButton.addTarget(self, action: #selector(didTapUploadImageButton), for: .primaryActionTriggered)
        
        let constraints = [
            AccountImageLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            AccountImageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            AccountImageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            AccountImageLabel.rightAnchor.constraint(lessThanOrEqualTo: SearchButton.leftAnchor, constant: -10),
            
            SearchButton.centerYAnchor.constraint(equalTo: AccountImageLabel.centerYAnchor),
            SearchButton.rightAnchor.constraint(equalTo: UploadButton.leftAnchor, constant: -30),
            SearchButton.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 10),
            SearchButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            
            UploadButton.centerYAnchor.constraint(equalTo: AccountImageLabel.centerYAnchor),
            UploadButton.rightAnchor.constraint(equalTo: uploadedImageView.leftAnchor, constant: -40),
            UploadButton.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 10),
            UploadButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            
            uploadedImageView.centerYAnchor.constraint(equalTo: AccountImageLabel.centerYAnchor),
            uploadedImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 10),
            uploadedImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            uploadedImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapUploadImageButton() {
        delegate?.didTapUpload()
    }
}


