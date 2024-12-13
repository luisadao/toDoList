//
//  ToDoList.swift
//  ToDoList
//
//  Created by formando on 12/12/2024.
//
import Foundation

struct ToDoList: Codable, Equatable {
    let id: UUID
    var title: String
    var toDo: [ToDo]
    
    init(title: String, toDo: [ToDo] = []) {
        self.id = UUID()
        self.title = title
        self.toDo = toDo
    }
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("toDoLists").appendingPathExtension("plist")
    
    static func saveToDoLists(_ toDoLists: [ToDoList]) {
        let encoder = PropertyListEncoder()
        if let data = try? encoder.encode(toDoLists) {
            try? data.write(to: archiveURL, options: .noFileProtection)
        }
    }
    
    static func loadToDoLists() -> [ToDoList]? {
        if let data = try? Data(contentsOf: archiveURL) {
            let decoder = PropertyListDecoder()
            return try? decoder.decode([ToDoList].self, from: data)
        }
        return nil
    }
    
    static func loadSampleToDoLists() -> [ToDoList] {
            let toDo1 = ToDoList(title: "Work Tasks", toDo: [
                ToDo(title: "Finish project report", isComplete: false, dueDate: Date(), notes: "Complete the final draft of the report"),
                ToDo(title: "Prepare for meeting", isComplete: false, dueDate: Date().addingTimeInterval(3600), notes: "Prepare slides for the weekly update meeting")
            ])
            
            let toDo2 = ToDoList(title: "Home Tasks", toDo: [
                ToDo(title: "Do the laundry", isComplete: false, dueDate: Date(), notes: nil),
                ToDo(title: "Buy groceries", isComplete: false, dueDate: Date().addingTimeInterval(7200), notes: "Milk, Eggs, Bread")
            ])
            
            let toDo3 = ToDoList(title: "Fitness Goals", toDo: [
                ToDo(title: "Go for a run", isComplete: false, dueDate: Date(), notes: "Run 5km in the park"),
                ToDo(title: "Strength training", isComplete: false, dueDate: Date().addingTimeInterval(86400), notes: "Lift weights for 45 minutes")
            ])
            
            return [toDo1, toDo2, toDo3]
        }
}
