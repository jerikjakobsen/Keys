//
//  HomeScreen.swift
//  Keys
//
//  Created by John Jakobsen on 7/21/22.
//

import Foundation
import UIKit


class PasswordFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate  {
    
    var _passwordFeedView: PasswordFeedView
    //var _searchBarBlur: UIVisualEffectView
    
    init() {
        _passwordFeedView = PasswordFeedView()
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
        self.navigationController?.present(AddAccountViewController(), animated: true, completion: nil)
    }
    
}

// Table View Delegate
extension PasswordFeedViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel: AccountCellViewModel = AccountCellViewModel(username: "JohnUsernamelwhdgasljkhaljdkhasldkhashjdalksdbhjkasbd;aklbsdhjabkldjavshjdbaljksdvaksdhbljkagvsdbiluasgdkgasvlbdblasgjkdvaiu;sdvacksdvba;ksdvkaljksjdbasukgdvba;usdgvaksjhdbalisjgvdablskbdvasgjdb;asbdvkabsdi;ualbvsdvbasi;dba", email: "john@gmail.com", accountImage: UIImage(named: "gmail_logo"), accountTypeName: "Gmail")
        let cell: AccountInfoCell = AccountInfoCell(style: .default, reuseIdentifier: "AccountInfoCell", viewModel: cellViewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: AccountInfoCell = tableView.cellForRow(at: indexPath) as! AccountInfoCell
        cell.didSelectCell()
        let accountDetailViewModel: AccountDetailViewModel = AccountDetailViewModel(accountImage: UIImage(named: "gmail_logo"), accountTypeName: "Google", AccountInfo: [FieldInfoCellViewModel(fieldType: "Password", fieldContent: "pa55w0rd", isPassword: true, isCopyable: true, isLink: false),FieldInfoCellViewModel(fieldType: "Username", fieldContent: "Johnjawdajsdjnahjbdjabsdjhabjshdbahbsdjabvsdjbvajhsdbakhbsdkabskdbasbdkjabskjdbajkhsbdkhajbskdabksdbaksjdbaksbdkabsdkjabskhdbaksjbdkahsbdkjabsdkjbakjsd,bakjhsbdkabsdkabskdjabksjdbk", isPassword: false, isCopyable: true, isLink: false)], lastUpdated: Date.now, createdAt: Date.now)
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
