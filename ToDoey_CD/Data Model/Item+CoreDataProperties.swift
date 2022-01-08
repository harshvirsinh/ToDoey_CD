//
//  Item+CoreDataProperties.swift
//  ToDoey_CD
//
//  Created by Harshvirsinh Parmar on 08/01/22.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var title: String?
    @NSManaged public var done: Bool

}

extension Item : Identifiable {

}
