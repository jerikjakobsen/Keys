//
//  AccountDetailViewController.swift
//  Keys
//
//  Created by John Jakobsen on 7/24/22.
//

import Foundation
import UIKit

class AccountDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FieldInfoCellDelegate {
    
    var _viewModel: AccountDetailViewModel
    var _accountDetailView: AccountDetailView
    
    init(viewModel: AccountDetailViewModel) {
        _viewModel = viewModel
        _accountDetailView = AccountDetailView(viewModel: _viewModel)
        super.init(nibName: nil, bundle: nil)
        _accountDetailView.delegate = self
        _accountDetailView.dataSource = self
        self.title = viewModel.entry.name.value
        self.view.addSubview(_accountDetailView)

        let accountDetailViewLayout = [
            _accountDetailView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            _accountDetailView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            _accountDetailView.topAnchor.constraint(equalTo: self.view.topAnchor),
            _accountDetailView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(accountDetailViewLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AccountDetailViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _viewModel.entry.KeyVals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = FieldInfoCellViewModel(keyval: _viewModel.entry.KeyVals[indexPath.row])
        //let cell: FieldInfoCell = FieldInfoCell(style: .default, reuseIdentifier: "FieldInfoCell", viewModel: cellViewModel)
        let cell: FieldInfoCell = (tableView.dequeueReusableCell(withIdentifier: "FieldInfoCell") as? FieldInfoCell) ?? FieldInfoCell(style: .default, reuseIdentifier: "FieldInfoCell", viewModel: cellViewModel)
        cell.setFieldInfoCell(viewModel: cellViewModel)
        cell._delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: FieldInfoCell = tableView.cellForRow(at: indexPath) as! FieldInfoCell
        cell.didSelectCell()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return _accountDetailView._headerView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        return
    }
    
    func didCopyField(fieldInfoCell: FieldInfoCell, copiedText: String) {
        let copyAlert = AlertView(title: "Copied!")
        copyAlert.layer.opacity = 0.0
        view.addSubview(copyAlert)
        let constraints = [
            copyAlert.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            copyAlert.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            copyAlert.heightAnchor.constraint(equalToConstant: 200),
            copyAlert.widthAnchor.constraint(equalToConstant: 180)
        ]
        NSLayoutConstraint.activate(constraints)
        
        
        UIView.animate(withDuration: 0.6) {
            copyAlert.layer.opacity = 1
        } completion: { completed in
            UIView.animate(withDuration: 0.6) {
                copyAlert.layer.opacity = 0
            } completion: { completed in
                copyAlert.removeFromSuperview()
            }
        }

    }
}
