//
//  PasswordFeedView.swift
//  Keys
//
//  Created by John Jakobsen on 7/21/22.
//

import Foundation
import UIKit

class PasswordFeedView: UITableView {
        
    var _searchBar: UISearchBar
    
    init() {
        _searchBar = UISearchBar()
        _searchBar.backgroundImage = _searchBar.backgroundImage?.blurredImage(with: .init(), radius: 30, atRect:_searchBar.frame)
        _searchBar.isTranslucent = true
        _searchBar.placeholder = "Search . . ."
        _searchBar.searchTextField.font = FontConstants.LabelMedium
        
        super.init(frame: CGRect(), style: .plain)
        
        self.register(AccountInfoCell.self, forCellReuseIdentifier: "AccountInfoCell")
        self.separatorStyle = .none
        self.translatesAutoresizingMaskIntoConstraints = false
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = 200
        self.sectionHeaderTopPadding = 0
    }
    required init?(coder: NSCoder) {
        _searchBar = UISearchBar()
        super.init(coder: coder)
    }
}
