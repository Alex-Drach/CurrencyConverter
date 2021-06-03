//
//  Item+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Alex on 16.05.2021.
//  Copyright © 2021 Alex Drach. All rights reserved.

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var firstCode: String
    @NSManaged public var secondCode: String
    @NSManaged public var amount: String
    @NSManaged public var date: String
    @NSManaged public var id: UUID

}

extension Item : Identifiable {

}
