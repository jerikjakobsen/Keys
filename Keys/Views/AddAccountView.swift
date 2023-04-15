//
//  AddAccountView.swift
//  Keys
//
//  Created by John Jakobsen on 8/5/22.
//

import Foundation
import UIKit

class AddAccountView: UITableView  {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.register(EditableNewFieldCell.self, forCellReuseIdentifier: "EditableNewFieldCell")
        self.translatesAutoresizingMaskIntoConstraints = false
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = 100
        self.sectionHeaderTopPadding = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
