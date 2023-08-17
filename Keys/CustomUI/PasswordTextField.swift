//
//  PasswordField.swift
//  Keys
//
//  Created by John Jakobsen on 8/16/23.
//

import Foundation
import UIKit

class PasswordTextField: UIView {
    let passwordTextField: UnderlinedTextField
    let visibilityButton: UIButton
    let showImage: UIImage?
    let dontShowImage: UIImage?
    var passwordVisible: Bool
    var text: String? {
        get {
            return self.passwordTextField.text
        }
    }
    
    override init(frame: CGRect) {
        self.passwordTextField = .init(placeholder: "Password")
        self.passwordTextField.isSecureTextEntry = true
        self.visibilityButton = .init()
        self.visibilityButton.translatesAutoresizingMaskIntoConstraints = false
        self.passwordVisible = false
        self.showImage = UIImage(named: "eye" )?.withTintColor(.gray)
        self.dontShowImage = UIImage(named: "eye.slash")?.withTintColor(.gray)
        self.visibilityButton.setImage(self.dontShowImage, for: .normal)
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.passwordTextField)
        self.addSubview(visibilityButton)
        self.visibilityButton.addTarget(self, action: #selector(self.didSelectVisibilityButton), for: .touchUpInside)
        
        let passwordTextFieldConstraints = [
            self.passwordTextField.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.passwordTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.passwordTextField.topAnchor.constraint(equalTo: self.topAnchor)
        ]
        NSLayoutConstraint.activate(passwordTextFieldConstraints)
        
        let visibilityButtonConstraints = [
            self.visibilityButton.leftAnchor.constraint(equalTo: self.passwordTextField.rightAnchor, constant: 10),
            self.visibilityButton.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.visibilityButton.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: 5),
            self.visibilityButton.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -5),
            self.visibilityButton.widthAnchor.constraint(equalTo: self.visibilityButton.heightAnchor)
        ]
        NSLayoutConstraint.activate(visibilityButtonConstraints)
    }
    
    convenience init() {
        self.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didSelectVisibilityButton() {
        self.passwordVisible = !self.passwordVisible
        let visibilityImage = self.passwordVisible ? self.showImage : self.dontShowImage
        self.passwordTextField.isSecureTextEntry = !self.passwordVisible
        self.visibilityButton.setImage(visibilityImage, for: .normal)
    }
}
