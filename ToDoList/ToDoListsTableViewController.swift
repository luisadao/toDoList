import UIKit

class ToDoListsTableViewController: UITableViewController {
    
    var toDoLists: [ToDoList] = [] // List of ToDoLists
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
        let toDoList = toDoLists[indexPath.row]
        cell.textLabel?.text = toDoList.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedList = toDoLists[indexPath.row]
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "ToDoTableViewController") as! ToDoTableViewController
        detailVC.toDoList = selectedList
        navigationController?.pushViewController(detailVC, animated: true)
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
        if segue.identifier == "showToDoList" {
            if let destinationVC = segue.destination as? ToDoTableViewController,
               let indexPath = tableView.indexPathForSelectedRow{
                let selectedList = toDoLists[indexPath.row]
                destinationVC.toDoList = selectedList
            }
        }
    }

    
    
}
