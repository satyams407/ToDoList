//
//  ViewModel.swift
//  TodoList
//
//  Created by Satyam Sehgal on 17/04/19.
//  Copyright © 2019 Satyam Sehgal. All rights reserved.
//

import Foundation

class ViewModel {
    
    func deleteTodoItem(with item: ToDo) {
        let predicate = NSPredicate(format: "SELF.title contains %@", item.title ?? "")
        if let todoObject = CoreDataUtil.fetchObjectsFromCoreData(fetchRequest: ToDo.fetchRequest(), predicate: predicate, inContext: CoreDataUtil.managedObjectContext!)?.first {
            CoreDataUtil.managedObjectContext?.delete(todoObject)
            CoreDataUtil.saveContext()
        }
    }
    
    func editTodoItem(_ item: ToDo, _ newItemTitle: String) {
        let predicate = NSPredicate(format: "SELF.title contains %@", item.title ?? "")
        if let todoObject = CoreDataUtil.fetchObjectsFromCoreData(fetchRequest: ToDo.fetchRequest(), predicate: predicate, inContext: CoreDataUtil.managedObjectContext!)?.first {
            todoObject.title = newItemTitle
            CoreDataUtil.saveContext()
        }
    }
}
