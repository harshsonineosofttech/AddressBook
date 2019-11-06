//
//  ContactViewController.swift
//  AddressBook
//
//  Created by Pratik Hirve on 06/11/19.
//  Copyright © 2019 Pratik Hirve. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var contactTableView: UITableView! {
        didSet {
            contactTableView.delegate = self
            contactTableView.dataSource = self
            contactTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            contactTableView.tableFooterView = UIView()
        }
    }

    @IBOutlet weak var contactNameLabel: UILabel!

    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Parameter
    var card: ContactCard?
    var dataSource: [String] = [] {
        didSet {
            contactTableView.reloadData()
        }
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        createDataSource(fromCard: card)

    }

    // MARK: - Helper Methods

    /// Creates an array from contact model
    /// - Parameter fromCard: Contact card
    fileprivate func createDataSource(fromCard: ContactCard?) {
        guard let contactModel = fromCard else {return}
        contactNameLabel.text = contactModel.firstName + " " + contactModel.lastName
        dataSource.append(contactModel.firstName)
        dataSource.append(contactModel.lastName)
        dataSource.append(contactModel.emailAddress)
        dataSource.append(contactModel.phoneNumber)
        dataSource.append(contactModel.address)
    }
}

extension ContactDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        if (dataSource.count - 1) == indexPath.row {
            cell.textLabel?.text = "\(dataSource[indexPath.row].replacingOccurrences(of: ",", with: "\n"))"
        } else {
            cell.textLabel?.text = "\(dataSource[indexPath.row])"
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
