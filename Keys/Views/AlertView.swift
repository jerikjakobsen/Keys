//
//  AlertView.swift
//  Keys
//
//  Created by John Jakobsen on 8/3/22.
//

import Foundation
import UIKit

class AlertView: UIView {
    let _copyImageView: UIImageView
    let _title: UILabel
    
    convenience init(title: String) {
        self.init(frame: CGRect())
        _title.text = title
        _title.translatesAutoresizingMaskIntoConstraints = false
        _copyImageView.translatesAutoresizingMaskIntoConstraints = false
        _copyImageView.tintColor = .white
        self.addSubview(_title)
        self.addSubview(_copyImageView)
        self.backgroundColor = ColorConstants.GrayColor
        self.layer.cornerRadius = 10
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            _copyImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            _copyImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            _copyImageView.heightAnchor.constraint(equalToConstant: 120),
            _copyImageView.widthAnchor.constraint(equalToConstant: 120),
            _title.topAnchor.constraint(equalTo: _copyImageView.bottomAnchor, constant: 10),
            _title.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    override init(frame: CGRect) {
        _title = UILabel()
        _copyImageView = UIImageView(image: UIImage(systemName: "doc.on.doc.fill"))
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
