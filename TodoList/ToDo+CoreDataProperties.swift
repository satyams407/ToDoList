//
//  ToDo+CoreDataProperties.swift
//  TodoList
//
//  Created by Satyam Sehgal on 18/04/19.
//  Copyright © 2019 Satyam Sehgal. All rights reserved.
//
//

import Foundation
import CoreData


extension ToDo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDo> {
        return NSFetchRequest<ToDo>(entityName: "ToDo")
    }

    @NSManaged public var detailDescription: String?
    @NSManaged public var title: String?

}
