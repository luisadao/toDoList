//
//  ToDoDetailTableViewController.swift
//  ToDoDetailTableViewController
//


import UIKit
import Foundation

class ToDoDetailViewController: UITableViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var isCompleteSwitch: UISwitch!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var dueDateDatePicker: UIDatePicker!

    @IBOutlet weak var dueDatePickerLabel: UILabel!
    

    @IBAction func saveButton(_ sender: UIButton) {
        guard let title = titleTextField.text, !title.isEmpty else {
                    let alert = UIAlertController(title: "Invalid Input", message: "Please enter a title for the task.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    present(alert, animated: true)
                    return
                }
                
                let isComplete = isCompleteSwitch.isOn
                let dueDate = dueDateDatePicker.date
                let notes = notesTextView.text
                
                if var toDo = toDo {
                    toDo.title = title
                    toDo.isComplete = isComplete
                    toDo.dueDate = dueDate
                    toDo.notes = notes
                    updateHandler?(toDo)
                } else {
                    let newToDo = ToDo(title: title, isComplete: isComplete, dueDate: dueDate, notes: notes)
                    updateHandler?(newToDo)
                }
                
                performSegue(withIdentifier: "saveUnwind", sender: self)
            }
        

    
    @IBOutlet weak var isCompletedLabel: UILabel!
    weak var delegate: ToDoDetailViewControllerDelegate?

    var toDo: ToDo? // The current ToDo being edited
    var toDoList: ToDoList! // The ToDoList this ToDo belongs to
    var updateHandler: ((ToDo) -> Void)? // Closure to update the ToDo in the list
    
    var isDatePickerHidden = true
    let dateLabelIndexPath = IndexPath(row: 0, section: 1)
    let datePickerIndexPath = IndexPath(row: 1, section: 1)
    let notesIndexPath = IndexPath(row: 0, section: 2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentDueDate: Date
        if let toDo = toDo {
            navigationItem.title = "Edit To-Do"
            titleTextField.text = toDo.title
            isCompleteSwitch.isOn = toDo.isComplete
            currentDueDate = toDo.dueDate
            notesTextView.text = toDo.notes
        } else {
            navigationItem.title = "New To-Do"
            currentDueDate = Date().addingTimeInterval(24 * 60 * 60) // Default due date: 1 day from now
        }
        
        dueDateDatePicker.date = currentDueDate
        updateDueDateLabel(date: currentDueDate)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard segue.identifier == "saveUnwind" else { return }

        // Get updated values from the UI
        let title = titleTextField.text ?? ""
        let isComplete = isCompleteSwitch.isOn
        let dueDate = dueDateDatePicker.date
        let notes = notesTextView.text ?? ""

        // Update existing ToDo or create a new one
        if var toDo = toDo {
            // Update the existing ToDo
            toDo.title = title
            toDo.isComplete = isComplete
            toDo.dueDate = dueDate
            toDo.notes = notes

            // Call the update handler to notify the parent view controller
            updateHandler?(toDo)
        }
    }


    func updateDueDateLabel(date: Date) {
        //dueDatePickerLabel.text = date.formatted(.dateTime.month(.defaultDigits).day().year(.twoDigits).hour().minute())
    }

    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }

  
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDueDateLabel(date: sender.date)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndexPath where isDatePickerHidden == true:
            return 0
        case notesIndexPath:
            return 200
        default:
            return UITableView.automaticDimension
        }
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndexPath:
            return 216
        case notesIndexPath:
            return 200
        default:
            return UITableView.automaticDimension
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == dateLabelIndexPath {
            isDatePickerHidden.toggle()
            updateDueDateLabel(date: dueDateDatePicker.date)
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    
}
