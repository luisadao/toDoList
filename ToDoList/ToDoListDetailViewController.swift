//
//  ToDoListDetailViewController.swift
//  ToDoList
//
//  Created by User on 13/12/2024.
//

import Foundation
import UIKit
class ToDoListDetailViewController: UITableViewController {

    @IBOutlet weak var titleTextField: UITextField!

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var titleTextLabel: UILabel!
    var toDoList: ToDoList!  // The ToDo List to edit
        var toDos: [ToDo] { return toDoList.toDo } // List of ToDos
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            if toDoList == nil { // If it's a new ToDo list
                titleTextField.text = "Untitled To-Do List" // Default title
            } else {
                // Set values from existing ToDoList if it's an edit screen
                titleTextField.text = toDoList.title

            }
        }
    
    
    
    // Handle saving changes to the ToDoList
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
            guard let title = titleTextField.text, !title.isEmpty else {
                let alert = UIAlertController(title: "Missing Information", message: "Please enter a title for the To-Do List.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
                return
            }

            // Create the new ToDo List object with only a title
            let newToDoList = ToDoList(title: title)
            
            // Save the ToDo List
            ToDoList.saveToDoLists([newToDoList])
            
            // Perform the unwind segue
            performSegue(withIdentifier: "unwindToToDoListTable", sender: self)
        }

    
    // Handle editing ToDo items in the list
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showToDoDetail" {
            if let destinationVC = segue.destination as? ToDoDetailViewController {
                // Pass the ToDoList and the selected ToDo item to the next view
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    let selectedToDo = toDoList.toDo[selectedIndexPath.row]
                    destinationVC.toDo = selectedToDo
                    destinationVC.toDoList = toDoList
                }
            }
        }
    }
}
