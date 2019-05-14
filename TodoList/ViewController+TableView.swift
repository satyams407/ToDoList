//
//  ViewController+TableView.swift
//  TodoList
//
//  Created by Satyam Sehgal on 17/04/19.
//  Copyright © 2019 Satyam Sehgal. All rights reserved.
//

import UIKit

// MARK: Table view data source and delegate methods
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shouldShowSearchResults ? filteredToDoList.count : toDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.cellIdentifier, for: indexPath)
        if let cell = tableCell as? ToDoTableViewCell {
            shouldShowSearchResults ? cell.updateCell(with: filteredToDoList[indexPath.row]) : cell.updateCell(with: toDoList[indexPath.row])
        }
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = deleteActionforTableRow(for: indexPath)
        let edit = editActionforTableRow(for: indexPath)
        
        return [delete, edit]
    }
    
    func editActionforTableRow(for indexPath: IndexPath) -> UITableViewRowAction  {
        let edit = UITableViewRowAction(style: .normal, title: StringConstants.editButtonTitle) { [weak self] (_, _) in
            guard let strongSelf = self else { return }
            
            let todoItem: ToDo = strongSelf.shouldShowSearchResults ? strongSelf.filteredToDoList[indexPath.row] : strongSelf.toDoList[indexPath.row]
            var alertTextField: UITextField?
            
            let textFieldHandler = {(textField: UITextField?) -> Void in
                alertTextField = textField
                alertTextField?.addTarget(self, action: #selector(strongSelf.textFieldDidChange(textField:)), for: .editingChanged)
                alertTextField?.placeholder = StringConstants.titleTextPlaceHolder
                alertTextField?.text = todoItem.title
                alertTextField?.autocapitalizationType = .allCharacters
                alertTextField?.clearButtonMode = .always
            }
            
            strongSelf.saveAction = UIAlertAction(title: StringConstants.saveButtonTitle, style: .default) { (_) in
                guard let strongSelf = self else { return }
                if let newTitle = alertTextField?.text {
                    strongSelf.handleEdit(for: todoItem, newItemTitle: newTitle)
                }
            }
            
            let cancelAction = UIAlertAction(title: StringConstants.cancelButtonTitle, style: UIAlertAction.Style.cancel)
            
            let alert = Utility.setupAlert(title: StringConstants.editTodo, message: StringConstants.emptyString, okAction: strongSelf.saveAction, cancelAction: cancelAction)
            Utility.showTextFieldAlert(alert: alert, textFieldHandler: textFieldHandler, onController: self!)
        }
        
        edit.backgroundColor = UIColor.blue
        return edit
    }
    
    func deleteActionforTableRow(for indexPath: IndexPath) -> UITableViewRowAction {
        let delete = UITableViewRowAction(style: .normal, title: StringConstants.deleteButtonTitle) { [weak self] (_, indexPath) in
            guard self != nil else { return }
            
            let cancelAction = UIAlertAction(title: StringConstants.cancelButtonTitle, style: UIAlertAction.Style.cancel)
            
            let okAction = UIAlertAction(title: StringConstants.okButtonTitle, style: .default) { (_) in
                guard self != nil else { return }
                let todoItem =  self!.shouldShowSearchResults ? self!.filteredToDoList[indexPath.row] : self!.toDoList[indexPath.row]
                self!.handleDeletion(item: todoItem)
            }
            
            Utility.showAlert(title: StringConstants.emptyString, message: StringConstants.editTodoMsg, okAction: okAction, cancelAction: cancelAction, onController: self!)
        }
        
        delete.backgroundColor = .red
        return delete
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        let name = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        saveAction?.isEnabled = name != StringConstants.emptyString
    }
}
