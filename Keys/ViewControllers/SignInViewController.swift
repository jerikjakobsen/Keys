//
//  SignInViewController.swift
//  Keys
//
//  Created by John Jakobsen on 7/28/23.
//

import Foundation
import UIKit
import KDBX
import Lottie

@objc class SignInViewController: UIViewController, SignInViewDelegate {
    
    var _signInView: SignInView
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self._signInView = SignInView()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self._signInView.delegate = self
        self.view.addSubview(_signInView)
        self.view.backgroundColor = .systemBackground
        let viewConstraints = [
            _signInView.leftAnchor.constraint(equalTo: view.leftAnchor),
            _signInView.rightAnchor.constraint(equalTo: view.rightAnchor),
            _signInView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            _signInView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ]
        NSLayoutConstraint.activate(viewConstraints)
        self.hideKeyboardWhenTapped()
    }
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapSignIn(_ button: UIButton, email: String, password: String) {
        
        //TODO: Check against backend if user can login
        self._signInView.showLoader()
        Task {
            defer {
                self._signInView.hideLoader()
            }
            do {
                guard let nm = NetworkManager.shared else {
                    let alert = UIAlertController(title: "Unable to Login", message: "Something went wrong", preferredStyle: .alert)
                    alert.addAction(.init(title: "OK", style: .default))
                    self.present(alert, animated: true)
                    return
                }
                let (error, kdbx) = try await nm.login(email: email, password: password)
                if let errorNotNil = error {
                    if let kdbxNotNil = kdbx {
                        let alert = UIAlertController(title: "", message: error, preferredStyle: .alert)
                        alert.addAction(.init(title: "Open Database", style: .default, handler: { action in
                            self.navigationController?.setViewControllers([PasswordFeedViewController(kdbx: kdbxNotNil)], animated: true)
                        }))
                        self.present(alert, animated: true)
                        return
                    }
                    let alert = UIAlertController(title: "Unable to Login", message: errorNotNil, preferredStyle: .alert)
                    alert.addAction(.init(title: "OK", style: .default))
                    self.present(alert, animated: true)
                    return
                }
                if let kdbxNotNil = kdbx {
                    // In this case the network was down and the user had a local databse, so we resorted to that database instead
                    self.navigationController?.setViewControllers([PasswordFeedViewController(kdbx: kdbxNotNil)], animated: true)
                } else {
                    // In this case the user passed the authentication, however we still need to fetch the servers database (if necessary)
                    let passwordFeedController = try await PasswordFeedViewController()
                    self.navigationController?.setViewControllers([passwordFeedController], animated: true)
                }
            } catch {
                print(error)
                let alert = UIAlertController(title: "Unable to Login", message: "Wrong Credentials", preferredStyle: .alert)
                alert.addAction(.init(title: "OK", style: .default))
                self.present(alert, animated: true)
                return
            }
        }
        
    }
    
    func didTapCreateAccount(_ button: UIButton) {
        self.navigationController?.pushViewController(CreateAccountViewController(), animated: true)
    }
}
