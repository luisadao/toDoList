import UIKit

class ToDoListsTableViewController: UITableViewController {
    
    var toDoLists: [ToDoList] = [] // List of ToDoLists
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ToDoListCell", bundle: nil), forCellReuseIdentifier: "ToDoListCell")

        // Clear the array first
            toDoLists.removeAll()

            // Load saved ToDoLists
            if let savedToDoLists = ToDoList.loadToDoLists() {
                toDoLists = savedToDoLists
            } else {
                toDoLists = ToDoList.loadSampleToDoLists() // Load sample data if none found
            }
            
            tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath) as! ToDoListCell
        let toDoList = toDoLists[indexPath.row]

        // Configure the cell to show the title of the ToDoList
        cell.titleLabel.text = toDoList.title

        return cell
    }


    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedToDoList = toDoLists[indexPath.row]
        let toDoTableVC = storyboard?.instantiateViewController(withIdentifier: "ToDoTableViewController") as! ToDoTableViewController
        toDoTableVC.toDoList = selectedToDoList // Assign the selected ToDoList
        navigationController?.pushViewController(toDoTableVC, animated: true)
    }


    @IBAction func addToDoList(_ sender: UIBarButtonItem) {
        // Create the alert with a text field to enter the title
            let alertController = UIAlertController(title: "New To-Do List", message: "Enter a title for the new To-Do List", preferredStyle: .alert)

            // Add a text field to the alert for the title
            alertController.addTextField { textField in
                textField.placeholder = "To-Do List Title"
            }

            // Add a "Create" action to the alert
            let createAction = UIAlertAction(title: "Create", style: .default) { [weak self] _ in
                // Get the title from the text field
                if let title = alertController.textFields?.first?.text, !title.isEmpty {
                    // Create the new ToDo List object
                    let newToDoList = ToDoList(title: title)
                    
                    // Add the new ToDo List to the array
                    self?.toDoLists.append(newToDoList)
                    
                    // Save the updated ToDoLists
                    ToDoList.saveToDoLists(self?.toDoLists ?? [])
                    
                    // Reload table data to reflect the new list
                    self?.tableView.reloadData()
                } else {
                    // Show an alert if the title is empty
                    let emptyTitleAlert = UIAlertController(title: "Missing Title", message: "Please enter a title for the To-Do List", preferredStyle: .alert)
                    emptyTitleAlert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(emptyTitleAlert, animated: true)
                }
            }

            // Add a "Cancel" action to the alert
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

            // Add the actions to the alert controller
            alertController.addAction(createAction)
            alertController.addAction(cancelAction)

            // Present the alert
            present(alertController, animated: true)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let toDoTableVC = segue.destination as? ToDoTableViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            let selectedToDoList = toDoLists[indexPath.row]
            toDoTableVC.toDoList = selectedToDoList // Pass the selected ToDoList
        }
    }
    
}
