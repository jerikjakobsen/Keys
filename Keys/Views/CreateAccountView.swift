//
//  CreateAccountView.swift
//  Keys
//
//  Created by John Jakobsen on 7/28/23.
//

import Foundation
import UIKit

protocol CreateAccountViewDelegate {
    func didTapCreateAccount(_ button: UIButton, username: String, password: String, confirmPassword: String)
}

class CreateAccountView: UIView {
    
    let titleLabel: UILabel
    let createAccountLabel: UILabel
    let usernameTextField: UnderlinedTextField
    let passwordTextField: UnderlinedTextField
    let confirmPasswordTextField: UnderlinedTextField
    let createAccountButton: UIButton
    var delegate: CreateAccountViewDelegate? = nil
    var animationView: LoadingAnimation
    
    override init(frame: CGRect) {
        self.titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Keys"
        titleLabel.font = FontConstants.LabelTitle1
        
        self.createAccountLabel = UILabel()
        createAccountLabel.translatesAutoresizingMaskIntoConstraints = false
        createAccountLabel.text = "Create New Account"
        createAccountLabel.font = FontConstants.LabelTitle2
        createAccountLabel.textColor = ColorConstants.GrayColor
        createAccountLabel.numberOfLines = 0
        createAccountLabel.textAlignment = .center
        
        self.usernameTextField = UnderlinedTextField(placeholder: "Username")
        self.passwordTextField = UnderlinedTextField(placeholder: "Password")
        self.confirmPasswordTextField = UnderlinedTextField(placeholder: "Confirm Password")
        self.createAccountButton = UIButton()
        createAccountButton.setTitle("Create Account", for: .normal)
        createAccountButton.setTitleColor(ColorConstants.ButtonTextColor, for: .normal)
        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.animationView = LoadingAnimation()
        
        super.init(frame: frame)
        
        self.addSubview(titleLabel)
        self.addSubview(createAccountLabel)
        self.addSubview(usernameTextField)
        self.addSubview(passwordTextField)
        self.addSubview(confirmPasswordTextField)
        self.addSubview(createAccountButton)
        self.addSubview(animationView)
        createAccountButton.addTarget(self, action: #selector(self.didTapCreateAccount), for: .touchUpInside)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    convenience init() {
        self.init(frame: CGRect())
        
        let titleLabelConstraints = [
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 80),
            titleLabel.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor, constant: 40),
            titleLabel.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -40)
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
        
        let createAccountLabelConstraints = [
            createAccountLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            createAccountLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            createAccountLabel.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor, constant: 40),
            createAccountLabel.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -40),
            createAccountLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6)
        ]
        NSLayoutConstraint.activate(createAccountLabelConstraints)
        
        let usernameTextFieldConstraints = [
            usernameTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            usernameTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -60),
            usernameTextField.topAnchor.constraint(greaterThanOrEqualTo: createAccountLabel.bottomAnchor, constant: 10),
            usernameTextField.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor, constant: 40),
            usernameTextField.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -40),
            usernameTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6)
        ]
        NSLayoutConstraint.activate(usernameTextFieldConstraints)
        
        let passwordTextFieldConstraints = [
            passwordTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 30),
            passwordTextField.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor, constant: 40),
            passwordTextField.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -40),
            passwordTextField.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor)
        ]
        NSLayoutConstraint.activate(passwordTextFieldConstraints)
        
        let confirmPasswordTextFieldConstraints = [
            confirmPasswordTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            confirmPasswordTextField.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor, constant: 40),
            confirmPasswordTextField.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -40),
            confirmPasswordTextField.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor)
        ]
        NSLayoutConstraint.activate(confirmPasswordTextFieldConstraints)
        
        let createAccountButtonConstraints = [
            createAccountButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            createAccountButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 40),
            createAccountButton.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor, constant: 40),
            createAccountButton.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -40),
            createAccountButton.widthAnchor.constraint(equalTo: confirmPasswordTextField.widthAnchor),
            createAccountButton.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(createAccountButtonConstraints)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let height = self.usernameTextField.frame.minY - self.createAccountLabel.frame.maxY - 20
        self.animationView.updateFrame(x: self.frame.width / 2 + self.frame.minX - height/2, y: self.createAccountLabel.frame.maxY + 10, width: height, height: height)
    }
    
    public func showLoader() {
        self.animationView.play()
    }
    
    public func hideLoader() {
        self.animationView.stop()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapCreateAccount() {
        if let username = self.usernameTextField.text, let password = self.passwordTextField.text, let confirmPassword = self.confirmPasswordTextField.text {
            delegate?.didTapCreateAccount(self.createAccountButton, username: username, password: password, confirmPassword: confirmPassword)
        }
    }
}
