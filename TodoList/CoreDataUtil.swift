//
//  CoreDataUtil.swift
//  TodoList
//
//  Created by Satyam Sehgal on 17/04/19.
//  Copyright © 2019 Satyam Sehgal. All rights reserved.
//

import CoreData
import UIKit

class CoreDataUtil {
    static var managedObjectContext: NSManagedObjectContext?
    
    static func saveContext() {
        DispatchQueue.main.async {
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        }
    }
    
    static func setupManagedObjectContext() {
        if managedObjectContext == nil {
            self.managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
            managedObjectContext?.mergePolicy =  NSMergeByPropertyObjectTrumpMergePolicy
        }
    }
    
    static func createNewObject(ofType entityName: String, inContext: NSManagedObjectContext? = CoreDataUtil.managedObjectContext) -> NSManagedObject? {
        if let entity = NSEntityDescription.entity(forEntityName: entityName, in: inContext!) {
            return NSManagedObject.init(entity: entity, insertInto: inContext)
        }
        return nil
    }
    
    static func fetchObjectsFromCoreData<T: NSManagedObject>(fetchRequest: NSFetchRequest<T>, predicate: NSPredicate?, inContext: NSManagedObjectContext? = CoreDataUtil.managedObjectContext) -> [T]? {
        fetchRequest.predicate = predicate
        do {
            return try inContext?.fetch(fetchRequest)
        } catch {
            print("error while fetching the objects")
            return nil
        }
    }
}
