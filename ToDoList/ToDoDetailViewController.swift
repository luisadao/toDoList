//
//  ToDoDetailTableViewController.swift
//  ToDoDetailTableViewController
//


import UIKit
import Foundation

class ToDoDetailViewController: UITableViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var isCompleteSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var dueDateDatePicker: UIDatePicker!

    @IBOutlet weak var dueDatePickerLabel: UILabel!
    
    @IBOutlet weak var isCompletedLabel: UILabel!
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
        updateSaveButtonState()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard segue.identifier == "saveUnwind" else { return }

        let title = titleTextField.text!
        let isComplete = isCompleteSwitch.isOn
        let dueDate = dueDateDatePicker.date
        let notes = notesTextView.text
        
        // If editing an existing ToDo, update it; otherwise, create a new one
        if toDo != nil {
            toDo?.title = title
            toDo?.isComplete = isComplete
            toDo?.dueDate = dueDate
            toDo?.notes = notes
        } else {
            toDo = ToDo(title: title, isComplete: isComplete, dueDate: dueDate, notes: notes)
        }

        // Update the ToDo in the ToDoList (via the updateHandler closure)
        if let updatedToDo = toDo {
            updateHandler?(updatedToDo)
        }
    }

    func updateDueDateLabel(date: Date) {
        dueDatePickerLabel.text = date.formatted(.dateTime.month(.defaultDigits).day().year(.twoDigits).hour().minute())
    }

    func updateSaveButtonState() {
        // Save button is enabled only when title text is not empty
        let shouldEnableSaveButton = titleTextField.text?.isEmpty == false
        saveButton.isEnabled = shouldEnableSaveButton
    }

    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }

    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }

    @IBAction func isCompleteButtonTapped(_ sender: UISwitch) {
        // No need to manually toggle UISwitch since it's state is stored in isCompleteSwitch.isOn
        updateSaveButtonState()
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
