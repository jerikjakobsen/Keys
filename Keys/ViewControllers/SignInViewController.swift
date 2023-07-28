//
//  SignInViewController.swift
//  Keys
//
//  Created by John Jakobsen on 7/28/23.
//

import Foundation
import UIKit

@objc class SignInViewController: UIViewController, SignInViewDelegate {
    @objc func didTapSignIn(_ button: UIButton, username: String, password: String) {
        //TODO: Check against backend if user can login
        self.navigationController?.setViewControllers([PasswordFeedViewController()], animated: true)
    }
    
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
    }
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
