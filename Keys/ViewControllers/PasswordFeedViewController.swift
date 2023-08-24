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

class PasswordFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate, AddAcountViewControllerDelegate, PasswordFeedViewDelegate  {
    
    var _passwordFeedView: PasswordFeedView
    private var _kdbxDatabase: KDBX
    private var searchResults: [EntryXML] = []
    
    init(kdbx: KDBX) {
        _passwordFeedView = PasswordFeedView()
        _kdbxDatabase = kdbx
        searchResults = kdbx.group.entries
        
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
        _passwordFeedView.searchDelegate = self
        self.title = "Accounts"
    }
    
    convenience init(_ d: Bool = false) async throws {
        guard let kdbx = try await NetworkManager.shared?.syncKDBX() else {
            throw NetworkHandlerError.UnableToSync
        }
        self.init(kdbx: kdbx)
    }
    
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.app"), style: .plain , target: self, action: #selector(didTapSettingsBarButton))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain , target: self, action: #selector(didTapLogoutButton))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapSettingsBarButton() {
        let addAccountViewController = AddAccountViewController()
        addAccountViewController.delegate = self
        self.navigationController?.pushViewController(addAccountViewController, animated: true)
    }
    
    @objc func didTapLogoutButton() {
        self.navigationController?.setViewControllers([SignInViewController()], animated: true)
    }
    
    func didCreateEntry(_ entry: EntryXML) {
        self._kdbxDatabase.group.addEntry(entry: entry)
        self.didChangeSearch(nil, text: self._passwordFeedView._searchBar.text ?? "")
        self._passwordFeedView.reloadData()
        Task.init {
            
            do {
                try await NetworkManager.shared?.saveKDBX(self._kdbxDatabase)
                let alert = UIAlertController(title: "Success!", message: "Saved New Entry", preferredStyle: .alert)
                alert.addAction(.init(title: "OK", style: .default))
                self.present(alert, animated: true)
                return
            } catch {
                print(error)
                let alert = UIAlertController(title: "Unable to Save Entry", message: "Something Went Wrong", preferredStyle: .alert)
                alert.addAction(.init(title: "OK", style: .default))
                self.present(alert, animated: true)
                return
            }
        }
    }
    
    func didChangeSearch(_ searchBar: UISearchBar?, text: String) {
        let searchText = text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if (searchText.count == 0) {
            self.searchResults = self._kdbxDatabase.group.entries
        } else {
            self.searchResults = self._kdbxDatabase.group.entries.filter { entry in
                return entry.name.value.lowercased().contains(searchText)
            }
        }
        self._passwordFeedView.reloadData()
    }
    
}

// Table View Delegate
extension PasswordFeedViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let entry: EntryXML = self.searchResults[indexPath.row]
        
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
//
//extension PasswordFeedViewController {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        guard let topCell: UITableViewCell = self._passwordFeedView.cellForRow(at: .init(row: 0, section: 0)) else {return}
//        if (_passwordFeedView._searchBar.frame.minY <= topCell.contentView.frame.minY) {
//            //_searchBarBlur.isHidden = false
//        } else {
//            //_searchBarBlur.isHidden = true
//        }
//    }
//}
