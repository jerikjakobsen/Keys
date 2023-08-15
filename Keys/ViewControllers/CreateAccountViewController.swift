//
//  CreateAccountViewController.swift
//  Keys
//
//  Created by John Jakobsen on 7/28/23.
//

import Foundation
import UIKit
import KDBX

class CreateAccountViewController: UIViewController, CreateAccountViewDelegate {
    
    let _createAccountView: CreateAccountView
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self._createAccountView = CreateAccountView()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self._createAccountView.delegate = self
        self.hideKeyboardWhenTapped()
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.view.addSubview(_createAccountView)
        self.view.backgroundColor = .systemBackground
        let viewConstraints = [
            _createAccountView.leftAnchor.constraint(equalTo: view.leftAnchor),
            _createAccountView.rightAnchor.constraint(equalTo: view.rightAnchor),
            _createAccountView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            _createAccountView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(viewConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapCreateAccount(_ button: UIButton, email: String, password: String, confirmPassword: String) {
        
        let emailLowercase = email.lowercased()
        
        if let errorMessage = CredentialHelpers.verifyCreationCredentials(email: emailLowercase, password: password, confirmPassword: confirmPassword) {
            let alert = UIAlertController(title: "Unable to create account", message: errorMessage, preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            self.present(alert, animated: true)
            return
        }
        
        self._createAccountView.showLoader()
//        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let fileURL = documentsDirectory.appendingPathComponent("\(email.lowercased()).kdbx")
//        let fileManager = FileManager.default
//        if (fileManager.fileExists(atPath: fileURL.path)) {
//            self._createAccountView.hideLoader()
//            let alert = UIAlertController(title: "Unable to Create Database", message: "There already exists a database with that username", preferredStyle: .alert)
//            alert.addAction(.init(title: "OK", style: .default))
//            self.present(alert, animated: true)
//            return
//        }
        Task.init {
            defer {
                self._createAccountView.hideLoader()
            }
            do {
                guard let nm = NetworkManager.shared else {
                    let alert = UIAlertController(title: "Unable to create an account", message: "Something went wrong", preferredStyle: .alert)
                    alert.addAction(.init(title: "OK", style: .default))
                    self.present(alert, animated: true)
                    return
                }
                
                let response = try await nm.createAccount(email: email, password: password)
                if let errorMessage = response {
                    self._createAccountView.hideLoader()
                    let alert = UIAlertController(title: "Unable to create an account", message: errorMessage, preferredStyle: .alert)
                    alert.addAction(.init(title: "OK", style: .default))
                    self.present(alert, animated: true)
                    return
                }
                
                let db = try KDBX(title: email)
                self.navigationController?.setViewControllers([PasswordFeedViewController(kdbx: db)], animated: true)
            } catch {
                print(error)
                let alert = UIAlertController(title: "Unable to Create Database", message: "", preferredStyle: .alert)
                alert.addAction(.init(title: "OK", style: .default))
                self.present(alert, animated: true)
                return
            }
        }
    }
}
