import UIKit

class ToDoListsTableViewController: UITableViewController {
    
    var toDoLists: [ToDoList] = [] // List of ToDoLists
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ToDoListCell", bundle: nil), forCellReuseIdentifier: "ToDoListCell")

        
        // Load saved ToDoLists
        if let savedToDoLists = ToDoList.loadToDoLists() {
            toDoLists = savedToDoLists
        } else {
            toDoLists = ToDoList.loadSampleToDoLists() // Load sample data if none found
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoLists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath) as! ToDoListCell
        let toDoList = toDoLists[indexPath.row]

        // Configure the cell
        cell.titleLabel.text = toDoList.title
        // Optionally, configure other UI elements in the cell
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedToDoList = toDoLists[indexPath.row]
        let toDoTableVC = storyboard?.instantiateViewController(withIdentifier: "ToDoTableViewController") as! ToDoTableViewController
        toDoTableVC.toDoList = selectedToDoList // Assign the selected ToDoList
        navigationController?.pushViewController(toDoTableVC, animated: true)
    }

    
    @IBAction func addToDoList(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "New ToDo List", message: "Enter the name of the new list", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "ToDo List Name"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            if let listName = alertController.textFields?.first?.text, !listName.isEmpty {
                let newToDoList = ToDoList(title: listName)
                self?.toDoLists.append(newToDoList)
                ToDoList.saveToDoLists(self?.toDoLists ?? [])
                self?.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
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
