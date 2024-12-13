//
//  ToDoListDetailTableViewController.swift
//  ToDoList
//
//  Created by formando on 12/12/2024.
//


import UIKit

class ToDoListDetailTableViewController: UITableViewController {
    var toDoList: ToDoList!
    var updateHandler: ((ToDoList) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = toDoList.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToDoItem))
    }
    
    @objc func addToDoItem() {
        let alert = UIAlertController(title: "New To-Do Item", message: "Enter details.", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Title" }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] _ in
            if let title = alert.textFields?.first?.text, !title.isEmpty {
                let newItem = ToDo(title: title)
                self?.toDoList.toDo.append(newItem)
                ToDoList.saveToDoLists([self?.toDoList].compactMap { $0 })
                self?.tableView.reloadData()
            }
        }))
        present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.toDoItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = toDoList.toDoItems[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.isComplete ? .checkmark : .none
        return cell
    }
}
