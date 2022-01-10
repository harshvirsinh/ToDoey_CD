//
//  Item+CoreDataProperties.swift
//  ToDoey_CD
//
//  Created by Harshvirsinh Parmar on 10/01/22.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var done: Bool
    @NSManaged public var title: String?
    @NSManaged public var parentCategory: Category?

}

extension Item : Identifiable {

}
