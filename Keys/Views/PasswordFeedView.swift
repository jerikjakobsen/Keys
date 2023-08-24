//
//  PasswordFeedView.swift
//  Keys
//
//  Created by John Jakobsen on 7/21/22.
//

import Foundation
import UIKit

protocol PasswordFeedViewDelegate: UITableViewDelegate {
    func didChangeSearch(_ searchBar: UISearchBar?, text: String)
}

class PasswordFeedView: UITableView, UISearchBarDelegate {
        
    var _searchBar: UISearchBar
    var searchDelegate: PasswordFeedViewDelegate? = nil
    
    init() {
        _searchBar = UISearchBar()
        _searchBar.backgroundImage = _searchBar.backgroundImage?.blurredImage(with: .init(), radius: 30, atRect:_searchBar.frame)
        _searchBar.isTranslucent = true
        _searchBar.placeholder = "Search . . ."
        _searchBar.searchTextField.font = FontConstants.LabelMedium
        
        super.init(frame: CGRect(), style: .plain)
        _searchBar.delegate = self
        
        self.register(AccountInfoCell.self, forCellReuseIdentifier: "AccountInfoCell")
        self.separatorStyle = .none
        self.translatesAutoresizingMaskIntoConstraints = false
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = 200
        self.sectionHeaderTopPadding = 0
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchDelegate?.didChangeSearch(searchBar, text: searchText)
    }
    
    required init?(coder: NSCoder) {
        _searchBar = UISearchBar()
        super.init(coder: coder)
    }
}
