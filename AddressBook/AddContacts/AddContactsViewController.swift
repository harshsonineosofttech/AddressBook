//
//  AddContactsViewController.swift
//  AddressBook
//
//  Created by Pratik Hirve on 05/11/19.
//  Copyright © 2019 Pratik Hirve. All rights reserved.
//

import UIKit

class AddContactsViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var addNewContacttableView: UITableView! {
        didSet {
            addNewContacttableView.delegate = self
            addNewContacttableView.dataSource = self
            addNewContacttableView.register(
                UINib(nibName: addContactsTableViewTextFieldCell, bundle: nil),
                forCellReuseIdentifier: addContactsTableViewTextFieldCell)

            addNewContacttableView.register(
            UINib(nibName: addContactsTableViewTextViewCell, bundle: nil),
            forCellReuseIdentifier: addContactsTableViewTextViewCell)

            addNewContacttableView.tableFooterView = UIView()
        }
    }

    // MARK: - IBAction
    @IBAction func backButton(_ sender: UIButton) {
            popViewController()
    }

    //swiftlint:disable force_try
    @IBAction func saveButton(_ sender: Any) {
        if validate(card: self.contactCard) {
            self.contactCard.id = UUID().uuidString
            try! realmConnector.realm.write {
                realmConnector.realm.add(self.contactCard)
            }
            showAlert(title: "Success", withMessage: "Contact has been added")
        }
    }

    // MARK: - Parameters
    let addContactsTableViewTextFieldCell = "AddContactsTableViewTextFieldCell"
    let addContactsTableViewTextViewCell = "AddContactsTableViewTextViewCell"

    var newHeight: CGFloat = 0

    var contactCard = ContactCard()

    var realmConnector: RealmConnector = RealmConnector.sharedInstance

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Helper Methods
    fileprivate func validate(card: ContactCard) -> Bool {
        if contactCard.firstName.isEmpty == true {
            showAlert(title: "Error", withMessage: "Please Enter Valid First Name")
            return false
        } else if contactCard.lastName.isEmpty == true {
            showAlert(title: "Error", withMessage: "Please Enter Valid Last Name")
            return false
        } else if contactCard.emailAddress.isEmpty == true || !contactCard.emailAddress.isValidEmail() {
            showAlert(title: "Error", withMessage: "Please Enter Valid Email Address")
            return false
        } else if contactCard.phoneNumber.isEmpty == true || !contactCard.phoneNumber.isValidPhoneNumber() {
            showAlert(title: "Error", withMessage: "Please Enter Valid Phone Number")
            return false
        } else if contactCard.address.isEmpty == true {
            showAlert(title: "Error", withMessage: "Please Enter Valid Address")
            return false
        }

        return true
    }

    fileprivate func showAlert(title: String, withMessage message: String) {
        let alert = UIAlertController(title: title,
                                      message: message, preferredStyle: UIAlertController.Style.alert)

        if title == "Success" {
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _  in
                self.popViewController()
            }))

        } else {
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }

        // show the alert
        self.present(alert, animated: true, completion: nil)

    }

    func popViewController() {
        navigationController?.popViewController(animated: true)
    }

}

// MARK: - Extension TableView DataSource and Delegate
extension AddContactsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AddNewContactCellTypes.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch AddNewContactCellTypes.allCases[indexPath.row] {

        case .firstName, .lastName, .emailAddress, .phoneNumber:
            guard let cell = tableView
                            .dequeueReusableCell(withIdentifier: addContactsTableViewTextFieldCell,
                                     for: indexPath) as? AddContactsTableViewTextFieldCell
                else {return UITableViewCell()}
            cell.tag = indexPath.row
            cell.delegate = self
            cell.cellType = AddNewContactCellTypes.allCases[indexPath.row]
            cell.textField.placeholder = AddNewContactCellTypes.allCases[indexPath.row].description()
            return cell

        case .address:
            guard let cell = tableView
                                    .dequeueReusableCell(withIdentifier: addContactsTableViewTextViewCell,
                                     for: indexPath) as? AddContactsTableViewTextViewCell
                else {return UITableViewCell()}
            cell.delegate = self
            cell.textChangedDelegate = self
            cell.tag = indexPath.row
            cell.cellType = AddNewContactCellTypes.allCases[indexPath.row]
            cell.addressTextView.placeholder = AddNewContactCellTypes.allCases[indexPath.row].description()
            return cell
        }

    }

}

extension AddContactsViewController: AddContactsTableViewTextViewCellDelegate {
    func addressTextViewHeightChanged() {
        self.addNewContacttableView.beginUpdates()
        self.addNewContacttableView.endUpdates()
    }
}
extension AddContactsViewController: AddContactsTableViewCellTextChangedDelegate {
    func textChangedFor(cellType: AddNewContactCellTypes, text: String) {
        switch cellType {
        case .firstName:
            self.contactCard.firstName = text
        case .lastName:
            self.contactCard.lastName = text
        case .emailAddress:
            self.contactCard.emailAddress = text
        case .phoneNumber:
            self.contactCard.phoneNumber = text
        case .address:
            self.contactCard.address = text
        }
    }

}
