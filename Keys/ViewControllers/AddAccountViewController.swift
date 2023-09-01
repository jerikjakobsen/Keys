//
//  AddAccountViewController.swift
//  Keys
//
//  Created by John Jakobsen on 8/5/22.
//

import Foundation
import UIKit
import XML

protocol AddAcountViewControllerDelegate {
    func didCreateEntry(_ entry: EntryXML)
}

class AddAccountViewController: UIViewController, UINavigationControllerDelegate, AccountTitleCellDelegate {
    
    let addAccountView: AddAccountView
    var accountName: String = ""
    var fields: [KeyValXML] = []
    var cellToDelete: EditableNewFieldCell?
    let imageSelector: UIImagePickerController
    var selectedAccountImage: UIImage?
    var delegate: AddAcountViewControllerDelegate? = nil
    var editingEntry: EntryXML? = nil
    var editingFields: [KeyValXML]? = nil
    var editingAccountName: XMLString? = nil
    var didChangeAccountImage: Bool = false
    
    init() {
        imageSelector = UIImagePickerController()
        addAccountView = AddAccountView(frame: CGRect())
        super.init(nibName: nil, bundle: nil)
        addAccountView.delegate = self
        addAccountView.dataSource = self
        self.view.addSubview(addAccountView)
        let constraints = [
            addAccountView.leftAnchor.constraint(equalTo: view.leftAnchor),
            addAccountView.rightAnchor.constraint(equalTo: view.rightAnchor),
            addAccountView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            addAccountView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.backgroundColor = .systemBackground
        self.navigationItem.rightBarButtonItem = .init(title: "Save", style: .done, target: self, action: #selector(self.addEntry))
        self.hideKeyboardWhenTapped()
    }
    
    static func Editing(entry: EntryXML, accountImage: UIImage? = nil) -> AddAccountViewController {
        let addAccountViewController = AddAccountViewController()
        addAccountViewController.editingEntry = entry
        addAccountViewController.editingFields = entry.KeyVals.map({ kv in
            return kv.copy() as! KeyValXML
        })
        
        addAccountViewController.editingAccountName = entry.name.copy() as! XMLString
        addAccountViewController.selectedAccountImage = accountImage
        addAccountViewController.addAccountView.reloadData()
        return addAccountViewController
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didChangeAccountTitle(_ accountName: String) {
        self.accountName = accountName
    }
    
    @objc func addEntry() {
        
        if self.editingEntry != nil {
            self.addEditedEntry()
            return
        }
        
        var entry: EntryXML? = nil
        if let accountImageData = self.selectedAccountImage?.pngData() {
            let imageUUID = UUID().uuidString
            do {
                try NetworkManager.shared?.saveImageLocally(imageData: accountImageData, imageID: imageUUID)
                entry = EntryXML(iconID: imageUUID, keyVals: self.fields, name: self.accountName)
            } catch {
                let alert = UIAlertController(title: "Could not save image", message: "", preferredStyle: .alert)
                alert.addAction(.init(title: "Create Without Account Image", style: .default, handler: { action in
                    entry = EntryXML(keyVals: self.fields, name: self.accountName)
                }))
                alert.addAction(.init(title: "Cancel", style: .cancel))
                self.present(alert, animated: true)
                return
            }
        } else {
            entry = EntryXML(keyVals: self.fields, name: self.accountName)
        }
        guard let createdEntry = entry else {
            let alert = UIAlertController(title: "Could not create entry", message: "", preferredStyle: .alert)
            alert.addAction(.init(title: "ok", style: .default))
            return
        }
        self.delegate?.didCreateEntry(createdEntry)
        self.navigationController?.popViewController(animated: true)
    }
    
    func addEditedEntry() {
        var imageUUID: String? = nil
        if didChangeAccountImage {
            imageUUID = UUID().uuidString
        }
        
        guard let editingEntryNotNil = editingEntry, let editingFieldsNotNil = editingFields, let entryNameNotNil = editingAccountName else {
            let alert = UIAlertController(title: "Something Went Wrong", message: "Could not save edit", preferredStyle: .alert)
            alert.addAction(.init(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
            return
        }
        
        if let imageUUIDNotNil = imageUUID, let accountImageData = self.selectedAccountImage?.pngData() {
            do {
                try NetworkManager.shared?.saveImageLocally(imageData: accountImageData, imageID: imageUUID!)
                editingEntryNotNil.iconID.value = imageUUIDNotNil
            } catch {
                let alert = UIAlertController(title: "Could not save image", message: "", preferredStyle: .alert)
                alert.addAction(.init(title: "Create Without Account Image", style: .default, handler: { action in
                    editingEntryNotNil.KeyVals = editingFieldsNotNil
                    editingEntryNotNil.name = entryNameNotNil
                    self.delegate?.didCreateEntry(editingEntryNotNil)
                    self.navigationController?.popViewController(animated: true)
                }))
                alert.addAction(.init(title: "Cancel", style: .cancel))
                self.present(alert, animated: true)
                return
            }
        }
        editingEntryNotNil.KeyVals = editingFieldsNotNil
        editingEntryNotNil.name = entryNameNotNil
        self.delegate?.didCreateEntry(editingEntryNotNil)
        self.navigationController?.popViewController(animated: true)
    }
}


extension AddAccountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section != 2 {
            return 1
        }
        
        if let _ = editingEntry, let editingFieldsNotNil = editingFields {
            return editingFieldsNotNil.count
        }
        return fields.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let titleCell = AccountTitleCell(style: .default, reuseIdentifier: "AccountTitleCell")
            titleCell.delegate = self
            if let _ = editingEntry, let editingAccountNameNotNil = editingAccountName {
                titleCell.setCell(title: editingAccountNameNotNil.value)
            }
            return titleCell
        case 1:
            let cell = AccountImageSelectorCell(style: .default, reuseIdentifier: "AccountImageSelectorCell")
            cell.delegate = self
            if self.selectedAccountImage != nil {
                cell.UploadButton.setImage(self.selectedAccountImage, for: .normal)
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditableNewFieldCell", for: indexPath) as? EditableNewFieldCell ?? EditableNewFieldCell(style: .default, reuseIdentifier: "EditableNewFieldCell")
            if let _ = editingEntry, let editingFieldsNotNil = editingFields {
                cell.setKeyVal(editingFieldsNotNil[indexPath.row])
            } else {
                cell.setKeyVal(self.fields[indexPath.row])
            }
            return cell
        default:
            let cell: UITableViewCell = UITableViewCell()
            let button: UIButton = UIButton()
            button.addTarget(self, action: #selector(didTapAddField), for: .primaryActionTriggered)
            let config = UIImage.SymbolConfiguration(pointSize: 60)
            let plusImageDefault = UIImage(systemName: "plus", withConfiguration: config)
            button.setImage(plusImageDefault, for: .normal)
            button.tintColor = ColorConstants.ButtonTextColor
            button.translatesAutoresizingMaskIntoConstraints = false
            button.layer.cornerRadius = 10
            cell.selectionStyle = .none
            cell.contentView.addSubview(button)
            let constraints = [
                button.leftAnchor.constraint(greaterThanOrEqualTo: cell.contentView.leftAnchor, constant: 20),
                button.rightAnchor.constraint(lessThanOrEqualTo: cell.contentView.rightAnchor, constant: -20),
                button.topAnchor.constraint(greaterThanOrEqualTo: cell.contentView.topAnchor, constant: 10),
                button.bottomAnchor.constraint(lessThanOrEqualTo: cell.contentView.bottomAnchor, constant: -10),
                button.heightAnchor.constraint(equalToConstant: 60),
                button.widthAnchor.constraint(equalToConstant: 80),
                button.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
            button.titleLabel?.text = "Add Field"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 2 {
            let action = UIContextualAction(style: .destructive,
                                            title: "Delete") { [weak self] (action, view, completionHandler) in
                                                self?.didTapDeleteField(indexPath: indexPath)
                                                completionHandler(true)
            }
            return UISwipeActionsConfiguration(actions: [action])
        } else {
            return UISwipeActionsConfiguration(actions: [])
        }
    }
    
    @objc func didTapAddField() {
        if let _ = editingEntry, var editingFieldsNotNil = editingFields {
            editingFieldsNotNil.append(KeyValXML(key: "Username", value: ""))
            self.addAccountView.insertRows(at: [IndexPath(row: editingFieldsNotNil.count-1, section: 2)], with: .top)
        } else {
            self.fields.append(KeyValXML(key: "Username", value: ""))
            self.addAccountView.insertRows(at: [IndexPath(row: fields.count-1, section: 2)], with: .top)
        }
    }
    
    @objc func didTapDeleteField(indexPath: IndexPath) {
        cellToDelete = addAccountView.cellForRow(at: indexPath) as? EditableNewFieldCell
        addAccountView.performBatchUpdates(nil) { completed in
            if completed {
                if let _ = self.editingEntry, var editingFieldsNotNil = self.editingFields {
                    editingFieldsNotNil.remove(at: indexPath.row)
                } else {
                    self.fields.remove(at: indexPath.row)
                }
                self.addAccountView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cellToDelete != nil && tableView.cellForRow(at: indexPath) == cellToDelete {
            return 0
        } else {
            return UITableView.automaticDimension
        }
    }
}

extension AddAccountViewController: UIImagePickerControllerDelegate, AccountImageSelectorCellProtocol {
    func didTapUpload() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imageSelector.delegate = self
            imageSelector.sourceType = .savedPhotosAlbum
            imageSelector.allowsEditing = false
            present(imageSelector, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedAccountImage = (info[.editedImage] ?? info[.originalImage]) as? UIImage {
            imageSelector.dismiss(animated: true, completion: nil)
            guard let cell: AccountImageSelectorCell = self.addAccountView.cellForRow(at: IndexPath(row: 0, section: 1)) as? AccountImageSelectorCell else {
                return
            }
            if let image: UIImage = resizeImage(image: selectedAccountImage, newWidth: 50, newHeight: 50) {
                cell.UploadButton.setImage(image, for: .normal)
                cell.UploadButton.imageView?.round()
                self.selectedAccountImage = image
                self.didChangeAccountImage = true
            }
        }
    }
    
}

func resizeImage(image: UIImage, newWidth: CGFloat, newHeight: CGFloat) -> UIImage? {
    let size = image.size
        
//    let widthRatio = newWidth / size.width
//    let heightRatio = newHeight / size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    let newSize: CGSize = CGSize(width: newWidth, height: newHeight)
//    if(widthRatio > heightRatio) {
//        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
//    } else {
//        newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
//    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(origin: .zero, size: newSize)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
}
