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
    var toDo: [ToDo] = []
    
    init(title: String, toDo: [ToDo] = []) {
        self.id = UUID()
        self.title = title
        self.toDo = toDo
    }
        
        static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        static let archiveURL = documentsDirectory.appendingPathComponent("toDoLists").appendingPathExtension("plist")
        
    // Save all ToDoLists to UserDefaults or a file
        static func saveToDoLists(_ toDoLists: [ToDoList]) {
            do {
                let data = try JSONEncoder().encode(toDoLists)
                UserDefaults.standard.set(data, forKey: "ToDoLists")
            } catch {
                print("Failed to save ToDoLists: \(error)")
            }
        }
        
        // Load all ToDoLists from UserDefaults or a file
        static func loadToDoLists() -> [ToDoList]? {
            guard let data = UserDefaults.standard.data(forKey: "ToDoLists") else { return nil }
            do {
                let toDoLists = try JSONDecoder().decode([ToDoList].self, from: data)
                return toDoLists
            } catch {
                print("Failed to load ToDoLists: \(error)")
                return nil
            }
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
