import UIKit

class ToDoTableViewController: UITableViewController {
    var toDoList: ToDoList! // The selected ToDoList
    var toDos: [ToDo] { return toDoList.toDo } // Get the ToDos for the list
    
    override func viewDidLoad() {
           super.viewDidLoad()
           tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ToDoCell")
           
           if let toDoList = toDoList {
               navigationItem.title = toDoList.title
           } else {
               print("Error: ToDoList not available")
           }
       }
       
       // Method to save all ToDoLists after changes
       func saveAllToDoLists() {
           guard var allToDoLists = ToDoList.loadToDoLists() else {
               ToDoList.saveToDoLists([toDoList])
               return
           }
           if let index = allToDoLists.firstIndex(where: { $0.id == toDoList.id }) {
               allToDoLists[index] = toDoList
           } else {
               allToDoLists.append(toDoList)
           }
           ToDoList.saveToDoLists(allToDoLists)
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
       
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let selectedToDo = toDos[indexPath.row]
           let detailVC = storyboard?.instantiateViewController(withIdentifier: "ToDoDetailViewController") as! ToDoDetailViewController
           
           // Pass the selected ToDo for editing
           detailVC.toDo = selectedToDo
           detailVC.updateHandler = { [weak self] updatedToDo in
               if let index = self?.toDoList.toDo.firstIndex(where: { $0.id == updatedToDo.id }) {
                   self?.toDoList.toDo[index] = updatedToDo
                   self?.saveAllToDoLists()
                   self?.tableView.reloadData()
               }
           }
           
           navigationController?.pushViewController(detailVC, animated: true)
       }
    
    @IBAction func addToDoItem(_ sender: UIBarButtonItem) {
        // Create a new ToDo with default values
            let newToDo = ToDo(title: "", isComplete: false, dueDate: Date(), notes: nil)
            
            // Instantiate the detail view controller
            let detailVC = storyboard?.instantiateViewController(withIdentifier: "ToDoDetailViewController") as! ToDoDetailViewController
            
            // Pass the new ToDo to the detailVC for editing
            detailVC.toDo = newToDo
            
            // Set the updateHandler closure to handle the ToDo once it's updated
            detailVC.updateHandler = { [weak self] updatedToDo in
                // Debug log to check the updated ToDo
                print("Updated ToDo: \(updatedToDo)") // Debug the title
                
                // Append the updated ToDo to the list
                self?.toDoList.toDo.append(updatedToDo)
                
                // Ensure to save the updated ToDoList
                if let toDoList = self?.toDoList {
                    ToDoList.saveToDoLists([toDoList])
                }
                
                // Reload the table view to reflect the new ToDo
                self?.tableView.reloadData()
            }
            
            // Push the ToDoDetailViewController to allow the user to edit the new ToDo
            navigationController?.pushViewController(detailVC, animated: true)
        }

            override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "showToDoDetail", let toDoDetailVC = segue.destination as? ToDoDetailViewController {
                    // Pass nil ToDo to indicate a new ToDo
                    toDoDetailVC.toDo = nil
                    toDoDetailVC.updateHandler = { newToDo in
                        // When the new ToDo is saved, add it to the list
                        self.toDoList.toDo.append(newToDo)
                        ToDo.saveToDos(self.toDoList.toDo)
                        self.tableView.reloadData() // Reload table to display the new ToDo
                    }
                }
            }

            @IBAction func unwindToToDoTable(segue: UIStoryboardSegue) {
                guard segue.identifier == "saveUnwind",
                      let sourceVC = segue.source as? ToDoDetailViewController,
                      let updatedToDo = sourceVC.toDo else { return }

                if let index = toDoList.toDo.firstIndex(where: { $0.id == updatedToDo.id }) {
                    // Update the existing item
                    toDoList.toDo[index] = updatedToDo
                } else {
                    // Add a new item
                    toDoList.toDo.append(updatedToDo)
                }
                
                saveAllToDoLists() // Save the updated list
                tableView.reloadData() // Refresh the table view
            }
        }
