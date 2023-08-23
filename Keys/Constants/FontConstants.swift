//
//  Font.swift
//  Keys
//
//  Created by John Jakobsen on 7/24/22.
//

import UIKit

struct FontConstants {
    static let LabelRegular: UIFont = UIFont(name: "MontserratRoman-Regular", size: 14.0) ?? .systemFont(ofSize: 14.0)
    static let LabelEmphasized: UIFont = UIFont(name: "MontserratRoman-Medium", size: 16.0) ?? .systemFont(ofSize: 16.0)
    static let LabelMedium: UIFont = UIFont(name: "MontserratRoman-Regular", size: 20.0) ?? .systemFont(ofSize: 20.0, weight: .regular)
    static let LabelMediumBold: UIFont = UIFont(name: "MontserratRoman-Medium", size: 24.0) ?? .systemFont(ofSize: 24.0, weight: .bold)
    static let LabelTitle1: UIFont = UIFont(name: "MontserratRoman-SemiBold", size: 30.0) ?? .systemFont(ofSize: 30, weight: .bold)
    static let LabelTitle2: UIFont = UIFont(name: "MontserratRoman-SemiBold", size: 18.0) ?? .systemFont(ofSize: 18, weight: .bold)
}
