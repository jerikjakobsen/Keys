//
//  SignInView.swift
//  Keys
//
//  Created by John Jakobsen on 7/27/23.
//

import Foundation
import UIKit

@objc protocol SignInViewDelegate {
    @objc func didTapSignIn(_ button: UIButton, username: String, password: String)
}

class SignInView: UIView {
    
    let titleLabel: UILabel
    let usernameTextField: UnderlinedTextField
    let passwordTextField: UnderlinedTextField
    let signInButton: UIButton
    var delegate: SignInViewDelegate?
    
    override init(frame: CGRect) {
        self.delegate = nil
        self.titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Keys"
        titleLabel.font = FontConstants.LabelTitle1
        
        self.usernameTextField = UnderlinedTextField(placeholder: "Username")
        self.passwordTextField = UnderlinedTextField(placeholder: "Password")
        
        self.signInButton = UIButton()
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.setTitleColor( ColorConstants.textColor, for: .normal)
        
        super.init(frame: frame)
        self.addSubview(titleLabel)
        self.addSubview(usernameTextField)
        self.addSubview(passwordTextField)
        self.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(self.didTapSignIn), for: .touchUpInside)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    convenience init() {
        self.init(frame: CGRect())
        
        let titleConstraints = [
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 100),
            titleLabel.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor, constant: 40),
            titleLabel.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -40)
        ]
        NSLayoutConstraint.activate(titleConstraints)
        
        let usernameConstraints = [
            usernameTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            usernameTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -20),
            usernameTextField.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 10),
            usernameTextField.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor, constant: 40),
            usernameTextField.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -40),
            usernameTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6)
        ]
        NSLayoutConstraint.activate(usernameConstraints)
        
        let passwordConstraints = [
            passwordTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
            passwordTextField.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor, constant: 40),
            passwordTextField.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -40),
            passwordTextField.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor)
        ]
        NSLayoutConstraint.activate(passwordConstraints)
        
        let signInButtonConstraints = [
            signInButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            signInButton.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor, constant: 40),
            signInButton.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -40),
            signInButton.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -20),
            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20)
        ]
        NSLayoutConstraint.activate(signInButtonConstraints)
    }
    
    @objc func didTapSignIn() {
        if let username = self.usernameTextField.text, let password = self.passwordTextField.text {
            delegate?.didTapSignIn(self.signInButton, username: username, password: password)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
