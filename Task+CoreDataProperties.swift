//
//  Task+CoreDataProperties.swift
//  CF-FinalProject-ToDo
//
//  Created by Chris Hahn on 10/19/17.
//  Copyright © 2017 Sturnella. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var taskDesc: String?
    @NSManaged public var parentList: List?

}
