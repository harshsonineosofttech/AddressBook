//
//  AddContactsEnum.swift
//  AddressBook
//
//  Created by Pratik Hirve on 06/11/19.
//  Copyright © 2019 Pratik Hirve. All rights reserved.
//

import Foundation

/// Types of Fields
enum AddNewContactCellTypes: String, CaseIterable {
    case firstName, lastName, emailAddress, phoneNumber, address

    func description() -> String {
        switch self {
        case .firstName:
            return "First Name"
        case .lastName:
            return "Last Name"
        case .emailAddress:
            return "Email Address"
        case .phoneNumber:
            return "Phone Number"
        case .address:
            return "Address"
        }
    }
}
