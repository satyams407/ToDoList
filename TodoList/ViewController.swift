//
//  ViewController.swift
//  TodoList
//
//  Created by Satyam Sehgal on 17/04/19.
//  Copyright © 2019 Satyam Sehgal. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var noDataAvaliableLabel: UILabel!
    @IBOutlet weak var toDoTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    
    var saveAction: UIAlertAction?
    var debounceTimer: Timer?
    var shouldShowSearchResults = false
    var viewModel = ViewModel()
    var filteredToDoList: [ToDo] = []
    var toDoList: [ToDo] = [] {
        didSet {
            if toDoList.count > 0 {
                toDoTableView.isHidden = false
                noDataAvaliableLabel.isHidden = true
            } else {
                toDoTableView.isHidden = true
                noDataAvaliableLabel.isHidden = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toDoTableView.estimatedRowHeight = 100
        toDoTableView.rowHeight = UITableView.automaticDimension
        CoreDataUtil.setupManagedObjectContext()
        setUpData()
        searchBar.isHidden = true
    }
    
    private func setUpData() {
        if let todoObjects = fetchLocalData(), todoObjects.count > 0 {
            self.toDoList = todoObjects
            toDoTableView.isHidden = false
            noDataAvaliableLabel.isHidden = true
        } else {
            toDoTableView.isHidden = true
            noDataAvaliableLabel.isHidden = false
        }
    }
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        var toDoTitleTextField = UITextField()
        var descriptionTextField = UITextField()
        
        let alert = UIAlertController(title: StringConstants.addTodoItem, message: StringConstants.emptyString, preferredStyle: .alert)
        let action = UIAlertAction(title: StringConstants.addItemTitle, style: .default) { (action) in
            
            if let context = CoreDataUtil.managedObjectContext {
                let todo = ToDo(context: context)
                let title = toDoTitleTextField.text
                let details = descriptionTextField.text
                
                if let title = title {
                    todo.title = title
                    todo.detailDescription = details
                    self.toDoList.append(todo)
                    CoreDataUtil.saveContext()
                    self.toDoTableView.reloadData()
                }
            }
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = StringConstants.titleTextPlaceHolder
            toDoTitleTextField = textField
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = StringConstants.addDescriptionMsg
            textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
            descriptionTextField = textField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
     func handleDeletion(item: ToDo) {
        viewModel.deleteTodoItem(with: item)
        if let todoObjs = fetchLocalData() {
            self.toDoList = todoObjs
            toDoTableView.reloadData()
        }
    }
    
     func handleEdit(for item: ToDo, newItemTitle: String) {
        viewModel.editTodoItem(item, newItemTitle)
        if let todoObjs = fetchLocalData() {
            self.toDoList = todoObjs
            toDoTableView.reloadData()
        }
    }
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        searchBar.isHidden = false
        searchButton.isHidden = true
        searchBar.showsCancelButton = true
        searchBar.placeholder = StringConstants.searchBarPlaceHolder
    }
}

// MARK: Fetching Data from local
extension ViewController {
    fileprivate func fetchLocalData() -> [ToDo]? {
       return CoreDataUtil.fetchObjectsFromCoreData(fetchRequest: ToDo.fetchRequest(), predicate: nil, inContext: CoreDataUtil.managedObjectContext ?? nil)
    }
}

// MARK: Search functionality
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.count > 2 {
            shouldShowSearchResults = true
            if let timer = debounceTimer {
                timer.invalidate()    // when search button is tapped multiple times
            }
            // start the timer
            debounceTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.updateSearchResult(_:)), userInfo: text, repeats: false)
        } else if shouldShowSearchResults && text.count < 3 {
            shouldShowSearchResults = false   //reseting it
            filteredToDoList.removeAll()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        searchBar.isHidden = true
        searchButton.isHidden = false
        shouldShowSearchResults = false
        filteredToDoList.removeAll()
        scrollToTop()
    }
    
    @objc func updateSearchResult(_ timer: Timer) {
        if let searchText = timer.userInfo as? String {
            self.filteredToDoList = self.toDoList.filter ({
                (($0.title ?? StringConstants.emptyString).range(of: searchText, options: .caseInsensitive) != nil) || (($0.detailDescription ?? StringConstants.emptyString).range(of: searchText, options: .caseInsensitive) != nil)
            })
        }
        scrollToTop()
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .milliseconds(200)) {
            DispatchQueue.main.async {
                self.searchBar.resignFirstResponder()
            }
        }
    }
    
    func scrollToTop() {
        UIView.animate(withDuration: 0.3, animations: {
            self.toDoTableView.reloadData()
        }, completion: { (_) in
            self.toDoTableView.contentOffset = CGPoint.init(x: 0, y: 0)
        })
    }
}

