//
//  RealmConnector.swift
//  AddressBook
//
//  Created by Pratik Hirve on 06/11/19.
//  Copyright © 2019 Pratik Hirve. All rights reserved.
//

import Foundation
import RealmSwift

//swiftlint:disable force_try

/// DataBase Connector
class RealmConnector {

    // MARK: - Attributes
    static var sharedInstance: RealmConnector = RealmConnector()

    var realm: Realm {
        return try! Realm()
    }
}
