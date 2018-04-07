//
//  List+CoreDataProperties.swift
//  CF-FinalProject-ToDo
//
//  Created by Chris Hahn on 10/19/17.
//  Copyright © 2017 Sturnella. All rights reserved.
//
//

import Foundation
import CoreData


extension List {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<List> {
        return NSFetchRequest<List>(entityName: "List")
    }

    @NSManaged public var listTitle: String?
    @NSManaged public var childTasks: NSSet?

}

// MARK: Generated accessors for childTasks
extension List {

    @objc(addChildTasksObject:)
    @NSManaged public func addToChildTasks(_ value: Task)

    @objc(removeChildTasksObject:)
    @NSManaged public func removeFromChildTasks(_ value: Task)

    @objc(addChildTasks:)
    @NSManaged public func addToChildTasks(_ values: NSSet)

    @objc(removeChildTasks:)
    @NSManaged public func removeFromChildTasks(_ values: NSSet)

}
