//
//  SignInView.swift
//  Keys
//
//  Created by John Jakobsen on 7/27/23.
//

import Foundation
import UIKit

protocol SignInViewDelegate {
    func didTapSignIn(_ button: UIButton, email: String, password: String)
    func didTapCreateAccount(_ button: UIButton)
}

class SignInView: UIView {
    
    let titleLabel: UILabel
    let emailTextField: UnderlinedTextField
    let passwordTextField: PasswordTextField
    let signInButton: UIButton
    let createAccountButton: UIButton
    var delegate: SignInViewDelegate?
    var animationView: LoadingAnimation
    
    override init(frame: CGRect) {
        self.delegate = nil
        self.titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Keys"
        titleLabel.font = FontConstants.LabelTitle1
        
        self.emailTextField = UnderlinedTextField(placeholder: "Username")
        self.passwordTextField = .init()
        
        self.signInButton = UIButton()
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.setTitleColor(ColorConstants.ButtonTextColor, for: .normal)
        
        self.createAccountButton = UIButton()
        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
        createAccountButton.setTitle("Create Account", for: .normal)
        createAccountButton.setTitleColor(ColorConstants.ButtonTextColor, for: .normal)
        
        self.animationView = .init()
        
        super.init(frame: frame)
        self.addSubview(titleLabel)
        self.addSubview(emailTextField)
        self.addSubview(passwordTextField)
        self.addSubview(signInButton)
        self.addSubview(createAccountButton)
        self.addSubview(animationView)
        signInButton.addTarget(self, action: #selector(self.didTapSignIn), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(self.didTapCreateAccount), for: .touchUpInside)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    convenience init() {
        self.init(frame: CGRect())
        
        let titleConstraints = [
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 80),
            titleLabel.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor, constant: 40),
            titleLabel.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -40)
        ]
        NSLayoutConstraint.activate(titleConstraints)
        
        let emailConstraints = [
            emailTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emailTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -60),
            emailTextField.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 10),
            emailTextField.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor, constant: 40),
            emailTextField.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -40),
            emailTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6)
        ]
        NSLayoutConstraint.activate(emailConstraints)
        
        let passwordConstraints = [
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            passwordTextField.leftAnchor.constraint(equalTo: self.emailTextField.leftAnchor),
            passwordTextField.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -20),
            passwordTextField.passwordTextField.rightAnchor.constraint(equalTo: self.emailTextField.rightAnchor),
            //passwordTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor)
        ]
        NSLayoutConstraint.activate(passwordConstraints)
        
        let signInButtonConstraints = [
            signInButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            signInButton.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor, constant: 40),
            signInButton.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -40),
            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20)
        ]
        NSLayoutConstraint.activate(signInButtonConstraints)
        
        let createAccountConstraints = [
            createAccountButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            createAccountButton.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor, constant: 40),
            createAccountButton.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -40),
            createAccountButton.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -20),
            createAccountButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10)
        ]
        NSLayoutConstraint.activate(createAccountConstraints)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let height = self.emailTextField.frame.minY - self.titleLabel.frame.maxY - 20
        self.animationView.updateFrame(x: self.frame.width / 2 + self.frame.minX - height/2, y: self.titleLabel.frame.maxY + 10, width: height, height: height)
    }
    
    @objc func didTapSignIn() {
        if let email = self.emailTextField.text, let password = self.passwordTextField.text {
            delegate?.didTapSignIn(self.signInButton, email: email, password: password)
        }
    }
    
    @objc func didTapCreateAccount() {
        delegate?.didTapCreateAccount(self.createAccountButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func showLoader() {
        self.animationView.play()
    }
    
    public func hideLoader() {
        self.animationView.stop()
    }
}
