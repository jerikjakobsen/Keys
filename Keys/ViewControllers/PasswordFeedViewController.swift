//
//  HomeScreen.swift
//  Keys
//
//  Created by John Jakobsen on 7/21/22.
//

import Foundation
import UIKit
import KDBX
import XML

class PasswordFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate, AddAcountViewControllerDelegate  {
    
    var _passwordFeedView: PasswordFeedView
    private var _kdbxDatabase: KDBX
    private var _password: String
    //var _searchBarBlur: UIVisualEffectView
    
    init(kdbx: KDBX, password: String) {
        _passwordFeedView = PasswordFeedView()
        _kdbxDatabase = kdbx
        _password = password
        //self._searchBarBlur = UIView.newBlurEffect(view: _passwordFeedView._searchBar)
        //_passwordFeedView._searchBar.insertSubview(_searchBarBlur, at: 1)
//        NSLayoutConstraint.activate([
//            _searchBarBlur.topAnchor.constraint(equalTo: _passwordFeedView._searchBar.topAnchor),
//            _searchBarBlur.leadingAnchor.constraint(equalTo: _passwordFeedView._searchBar.leadingAnchor),
//            _searchBarBlur.heightAnchor.constraint(equalTo: _passwordFeedView._searchBar.heightAnchor),
//            _searchBarBlur.widthAnchor.constraint(equalTo: _passwordFeedView._searchBar.widthAnchor)
//        ])
        super.init(nibName: nil, bundle: nil)
        self.view.addSubview(_passwordFeedView)
        
        let passwordFeedViewLayout = [
            _passwordFeedView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            _passwordFeedView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            _passwordFeedView.topAnchor.constraint(equalTo: self.view.topAnchor),
            _passwordFeedView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(passwordFeedViewLayout)
        _passwordFeedView.delegate = self
        _passwordFeedView.dataSource = self
        _passwordFeedView._searchBar.delegate = self
        self.title = "Accounts"
    }
    
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.app"), style: .plain , target: self, action: #selector(didTapSettingsBarButton))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapSettingsBarButton() {
        let addAccountViewController = AddAccountViewController()
        addAccountViewController.delegate = self
        self.navigationController?.pushViewController(addAccountViewController, animated: true)
    }
    
    func didCreateEntry(_ entry: EntryXML) {
        self._kdbxDatabase.group.addEntry(entry: entry)
        self._passwordFeedView.reloadData()
    }
    
}

// Table View Delegate
extension PasswordFeedViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _kdbxDatabase.group.entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let entry: EntryXML = _kdbxDatabase.group.entries[indexPath.row]
        
        let cellViewModel: AccountCellViewModel = AccountCellViewModel(entry: entry)
        let cell: AccountInfoCell = AccountInfoCell(style: .default, reuseIdentifier: "AccountInfoCell", viewModel: cellViewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: AccountInfoCell = tableView.cellForRow(at: indexPath) as! AccountInfoCell
        cell.didSelectCell()
        let accountDetailViewModel: AccountDetailViewModel = AccountDetailViewModel(entry: cell._viewModel.entry)
        self.navigationController?.pushViewController(AccountDetailViewController(viewModel: accountDetailViewModel), animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return _passwordFeedView._searchBar
    }
    
}

extension PasswordFeedViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let topCell: UITableViewCell = self._passwordFeedView.cellForRow(at: .init(row: 0, section: 0)) else {return}
        if (_passwordFeedView._searchBar.frame.minY <= topCell.contentView.frame.minY) {
            //_searchBarBlur.isHidden = false
        } else {
            //_searchBarBlur.isHidden = true
        }
    }
}
