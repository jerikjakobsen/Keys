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
    
    func didTapSignIn(_ button: UIButton, username: String, password: String) {
        //TODO: Check against backend if user can login
        self._signInView.showLoader()
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent("\(username.lowercased()).kdbx")
        let fileManager = FileManager.default
        if (!fileManager.fileExists(atPath: fileURL.path)) {
            self._signInView.hideLoader()
            let alert = UIAlertController(title: "Unable to Login", message: "No database found with that username", preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            self.present(alert, animated: true)
            return
        }
        Task.init {
            do {
                let fileHandle = try FileHandle(forReadingFrom: fileURL)
                defer { fileHandle.closeFile() }

                let fileData = fileHandle.readDataToEndOfFile()
               
                let kdbx = try await KDBX.fromEncryptedData(fileData, password: password)
                self._signInView.hideLoader()
                self.navigationController?.setViewControllers([PasswordFeedViewController(kdbx: kdbx, password: password)], animated: true)
            } catch {
                self._signInView.hideLoader()
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
