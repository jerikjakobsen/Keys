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
    
    func didTapCreateAccount(_ button: UIButton, username: String, password: String, confirmPassword: String) {
    }
}
