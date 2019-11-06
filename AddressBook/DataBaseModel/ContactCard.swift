//
//  ContactCard.swift
//  AddressBook
//
//  Created by Pratik Hirve on 06/11/19.
//  Copyright © 2019 Pratik Hirve. All rights reserved.
//

import Foundation
import RealmSwift

/// ContactCard Model with primary key as ID
class ContactCard: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var emailAddress: String = ""
    @objc dynamic var phoneNumber: String = ""
    @objc dynamic var address: String = ""

    override class func primaryKey() -> String? {
        return "id"
    }
}
