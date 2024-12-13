import UIKit

class ToDoTableViewController: UITableViewController {
    var toDoList: ToDoList! // The selected ToDoList
    var toDos: [ToDo] { return toDoList.toDo } // Get the ToDos for the list
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let toDoList = toDoList{
            navigationItem.title = toDoList.title
        }else{
            print("error")
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        let toDo = toDos[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = toDo.title
        content.secondaryText = toDo.isComplete ? "Complete" : "Incomplete"
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            toDoList.toDo.remove(at: indexPath.row)
            ToDoList.saveToDoLists([toDoList]) // Save changes
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @IBAction func addToDoItem(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "New ToDo", message: "Enter details for the new ToDo", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "ToDo Name"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            if let toDoName = alertController.textFields?.first?.text, !toDoName.isEmpty {
                let newToDo = ToDo(title: toDoName, isComplete: false, dueDate: Date(), notes: nil)
                self?.toDoList.toDo.append(newToDo)
                ToDoList.saveToDoLists([self?.toDoList].compactMap { $0 })
                self?.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}