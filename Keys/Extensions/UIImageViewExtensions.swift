//
//  UIImageViewExtensions.swift
//  Keys
//
//  Created by John Jakobsen on 8/23/23.
//

import Foundation
import UIKit

extension UIImageView {
    func round() {
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}
