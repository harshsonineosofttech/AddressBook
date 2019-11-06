//
//  ViewController.swift
//  AddressBook
//
//  Created by Pratik Hirve on 05/11/19.
//  Copyright © 2019 Pratik Hirve. All rights reserved.
//

import UIKit
import SDStateTableView
import RealmSwift

class BaseLineViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: SDStateTableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            tableView.tableFooterView = UIView()
            self.tableView.setState(.withImage(image: UIImage(named: "emptyTableViewImage"),
                                               title: "No Contacts",
                                               message: "User the '+' icon to add new contact"))
        }
    }

    // MARK: - Parameter

    var contactCards: Results<ContactCard>? {
        didSet {

            if contactCards?.isEmpty == true {
                self.tableView.setState(.withImage(image: UIImage(named: "emptyTableViewImage"),
                                                   title: "No Contacts",
                                                   message: "User the '+' icon to add new contact"))
                tableView.separatorStyle = .none
                self.reloadAddressBookTable()

            } else {
                tableView.separatorStyle = .singleLine
                self.reloadAddressBookTable()
                self.tableView.setState(.dataAvailable)
            }

        }
    }

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchSavedContacts()
    }

    // MARK: - Helper Methods
    fileprivate func fetchSavedContacts() {
        contactCards = RealmConnector.sharedInstance.realm.objects(ContactCard.self)
    }

    fileprivate func reloadAddressBookTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - Extension TableView Delegate and DataSource
extension BaseLineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let cards = contactCards, !cards.isEmpty {
            return cards.count
        } else {

            return 0
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = self.contactCards?[indexPath.row].firstName
        return cell
    }

    //swiftlint:disable line_length
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let controller = self.storyboard?.instantiateViewController(identifier: "ContactDetailViewController") as? ContactDetailViewController, let card =  contactCards?[indexPath.row] else {return}
        controller.card = card
        navigationController?.pushViewController(controller, animated: true)
    }

    //swiftlint:disable force_try
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {

            guard let id = contactCards?[indexPath.row].id,
                let card = RealmConnector
                    .sharedInstance
                    .realm
                    .objects(ContactCard.self)
                    .filter("id = %@", id).first
            else {return}

            try! RealmConnector.sharedInstance.realm.write {
                RealmConnector.sharedInstance.realm.delete(card)
            }
            _ = contactCards?.dropFirst(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
