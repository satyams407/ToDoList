//
//  TodoListTests.swift
//  TodoListTests
//
//  Created by Satyam Sehgal on 17/04/19.
//  Copyright © 2019 Satyam Sehgal. All rights reserved.
//

import XCTest
import CoreData
@testable import TodoList

class TodoListTests: XCTestCase {
    var toDo: ToDo?
    var vm: ViewModel?
    
    override func setUp() {
        CoreDataUtil.setupManagedObjectContext()
        vm = ViewModel()
        self.createToDoObject() { _ in
            if let toDoObject = CoreDataUtil.fetchObjectsFromCoreData(fetchRequest: ToDo.fetchRequest(), predicate: nil, inContext: CoreDataUtil.managedObjectContext!)?.first {
               self.toDo = toDoObject
            }
        }
    }

    override func tearDown() {
        toDo = nil
        vm = nil
    }
    
    func testHandleEditSuccess() {
        guard let toDoTestObj = self.toDo else {
            XCTFail()
            return
        }
        let newItemTitle = "New Title"
        vm?.editTodoItem(toDoTestObj, newItemTitle)
        let predicate = NSPredicate(format: "SELF.title contains %@", newItemTitle)
        let todoObject = CoreDataUtil.fetchObjectsFromCoreData(fetchRequest: ToDo.fetchRequest(), predicate: predicate, inContext: CoreDataUtil.managedObjectContext!)?.first
        XCTAssertTrue(newItemTitle.compare(todoObject?.title ?? "") == .orderedSame, "Successfully edited the todo item")
    }
    
    func testHandleDeletionSuccess() {
        guard let toDoTestObj = self.toDo else {
            XCTFail()
            return
        }
        vm?.deleteTodoItem(with: toDoTestObj)
        let predicate = NSPredicate(format: "SELF.title contains %@", toDoTestObj.title ?? "")
        let todoObject = CoreDataUtil.fetchObjectsFromCoreData(fetchRequest: ToDo.fetchRequest(), predicate: predicate, inContext: CoreDataUtil.managedObjectContext!)?.first
        XCTAssertNil(todoObject, "Successfully deleted the todo item")
    }
   
    func createToDoObject(completionHandler: @escaping (ToDo?) -> Void) {
        guard let toDoObject = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: CoreDataUtil.managedObjectContext!) as? ToDo else {
            completionHandler(nil)
            return
        }
        toDoObject.title = "It's a test title"
        toDoObject.detailDescription = "This is a detail description"
        CoreDataUtil.saveContext()
        completionHandler(toDoObject)
    }
}

