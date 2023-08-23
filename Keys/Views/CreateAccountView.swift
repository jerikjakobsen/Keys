//
//  CreateAccountView.swift
//  Keys
//
//  Created by John Jakobsen on 7/28/23.
//

import Foundation
import UIKit

protocol CreateAccountViewDelegate {
    func didTapCreateAccount(_ button: UIButton, email: String, password: String, confirmPassword: String)
}

class CreateAccountView: UIView {
    
    let titleLabel: UILabel
    let createAccountLabel: UILabel
    let emailTextField: UnderlinedTextField
    let passwordTextField: PasswordTextField
    let confirmPasswordTextField: PasswordTextField
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
        
        self.emailTextField = UnderlinedTextField(placeholder: "Email")
        self.passwordTextField = .init()
        self.confirmPasswordTextField = .init()
        self.createAccountButton = UIButton()
        createAccountButton.setTitle("Create Account", for: .normal)
        createAccountButton.setTitleColor(ColorConstants.ButtonTextColor, for: .normal)
        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
        createAccountButton.titleLabel?.font = FontConstants.LabelMedium
        self.animationView = LoadingAnimation()
        
        super.init(frame: frame)
        
        self.addSubview(titleLabel)
        self.addSubview(createAccountLabel)
        self.addSubview(emailTextField)
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
        
        let emailTextFieldConstraints = [
            emailTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emailTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -60),
            emailTextField.topAnchor.constraint(greaterThanOrEqualTo: createAccountLabel.bottomAnchor, constant: 10),
            emailTextField.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor, constant: 40),
            emailTextField.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -40),
            emailTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6)
        ]
        NSLayoutConstraint.activate(emailTextFieldConstraints)
        
        let passwordTextFieldConstraints = [
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            passwordTextField.leftAnchor.constraint(equalTo: self.emailTextField.leftAnchor),
            passwordTextField.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -20),
            passwordTextField.passwordTextField.rightAnchor.constraint(equalTo: self.emailTextField.rightAnchor),
        ]
        NSLayoutConstraint.activate(passwordTextFieldConstraints)
        
        let confirmPasswordTextFieldConstraints = [
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            confirmPasswordTextField.leftAnchor.constraint(equalTo: self.passwordTextField.leftAnchor),
            confirmPasswordTextField.rightAnchor.constraint(equalTo: self.passwordTextField.rightAnchor)
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
        let height = self.emailTextField.frame.minY - self.createAccountLabel.frame.maxY - 20
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
        if let email = self.emailTextField.text, let password = self.passwordTextField.text, let confirmPassword = self.confirmPasswordTextField.text {
            delegate?.didTapCreateAccount(self.createAccountButton, email: email, password: password, confirmPassword: confirmPassword)
        }
    }
}
