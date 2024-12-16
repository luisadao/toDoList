//
//  ToDoTableViewController.swift
//  ToDoTableViewController
//


import UIKit

class ToDoTableViewController: UITableViewController, ToDoCellDelegate {
    var appUser: AppUser?
    var toDos = [ToDo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Call the async method in viewDidLoad to get the current user session
                Task {
                    do {
                        appUser = try await AuthManager.shared.getCurrentSession()
                        // Fetch to-dos from the database after getting the user session
                        if let userId = appUser?.uid.lowercased() {
                            print(userId)
                            print("fetching todos")
                            await fetchToDos(for: userId.lowercased())
                        }
                    } catch {
                        // Handle error
                        print("Failed to fetch user session: \(error.localizedDescription)")
                    }
                }
            }

            // MARK: - Fetch To-Dos from the Database

            func fetchToDos(for userId: String) async {
                do {
                    let fetchedToDos = try await DatabaseManager.shared.fetchToDoItems(for: userId.lowercased())
                    print(fetchedToDos)
                    self.toDos = fetchedToDos
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error fetching to-dos: \(error.localizedDescription)")
                }
            }

            // MARK: - Table view data source

            override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return toDos.count
            }

            override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellIdentifier", for: indexPath) as! ToDoCell

                let toDo = toDos[indexPath.row]
                cell.titleLabel?.text = toDo.title
                cell.isCompleteButton.isSelected = toDo.isComplete
                cell.delegate = self
                
                return cell
            }

            override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
                return true
            }

            override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
                if editingStyle == .delete {
                    let toDo = toDos[indexPath.row]
                    Task {
                        do {
                            // Delete the to-do item from the database
                            try await DatabaseManager.shared.deleteToDoItem(id: toDo.id!)
                            // Remove from local array and update table
                            toDos.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .automatic)
                        } catch {
                            print("Error deleting to-do: \(error.localizedDescription)")
                        }
                    }
                }
            }

            @IBAction func unwindToToDoList(segue: UIStoryboardSegue) {
                guard segue.identifier == "saveUnwind" else { return }
                let sourceViewController = segue.source as! ToDoDetailTableViewController

                if let toDo = sourceViewController.toDo {
                    if let indexOfExistingToDo = toDos.firstIndex(of: toDo) {
                        toDos[indexOfExistingToDo] = toDo
                        tableView.reloadRows(at: [IndexPath(row: indexOfExistingToDo, section: 0)], with: .automatic)
                    } else {
                        let newIndexPath = IndexPath(row: toDos.count, section: 0)
                        toDos.append(toDo)
                        tableView.insertRows(at: [newIndexPath], with: .automatic)
                    }
                }
                
                // Refresh to-dos after adding or editing
                if let userId = appUser?.uid.lowercased() {
                    Task {
                        await fetchToDos(for: userId.lowercased())
                    }
                }
            }

            @IBSegueAction func editToDo(_ coder: NSCoder, sender: Any?) -> ToDoDetailTableViewController? {
                let detailController = ToDoDetailTableViewController(coder: coder)
                
                guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
                    return detailController
                }
                
                tableView.deselectRow(at: indexPath, animated: true)
                
                detailController?.toDo = toDos[indexPath.row]
                
                return detailController
            }
            
            func checkmarkTapped(sender: ToDoCell) {
                if let indexPath = tableView.indexPath(for: sender) {
                    var toDo = toDos[indexPath.row]
                    toDo.isComplete.toggle()
                    toDos[indexPath.row] = toDo
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                    ToDo.saveToDos(toDos)
                }
            }
        }
