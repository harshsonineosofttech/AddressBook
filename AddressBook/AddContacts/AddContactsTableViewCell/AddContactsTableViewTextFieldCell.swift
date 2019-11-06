//
//  AddContactsTableViewCell.swift
//  AddressBook
//
//  Created by Pratik Hirve on 05/11/19.
//  Copyright © 2019 Pratik Hirve. All rights reserved.
//

import UIKit
protocol AddContactsTableViewCellTextChangedDelegate: class {
    func textChangedFor(cellType: AddNewContactCellTypes, text: String)
}
class AddContactsTableViewTextFieldCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var textField: UITextField!

    // MARK: - IBAction
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        guard let text = sender.text, let cellType = self.cellType else {return}
        delegate?.textChangedFor(cellType: cellType, text: text)
    }

    // MARK: - Parameter
    weak var delegate: AddContactsTableViewCellTextChangedDelegate?
    var cellType: AddNewContactCellTypes?

    // MARK: - Cell Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    // MARK: - Helper Methods
    fileprivate func setup() {
        self.selectionStyle = .none

        guard let cellType = self.cellType else {
            print("Please set cellType")
                   return }

        switch cellType {
        case .firstName, .lastName, .address:
            textField.keyboardType = .default
        case .emailAddress:
            textField.keyboardType = .emailAddress
        case .phoneNumber:
            textField.keyboardType = .numberPad
        }
    }
}
