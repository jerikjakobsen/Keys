//
//  UIViewControllerExtensions.swift
//  Keys
//
//  Created by John Jakobsen on 7/31/23.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTapped() {
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
    @objc func dismissKeyboard() {
           view.endEditing(true)
       }
}
