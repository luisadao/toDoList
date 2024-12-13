//
//  ToDo.swift
//  ToDo
//


import Foundation

struct ToDo: Equatable, Codable {
    let id: UUID
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    
    init(title: String, isComplete: Bool, dueDate: Date, notes: String?) {
        self.id = UUID()
        self.title = title
        self.isComplete = isComplete
        self.dueDate = dueDate
        self.notes = notes
    }
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("toDos").appendingPathExtension("plist")
    
    static func saveToDos(_ toDos: [ToDo]) {
            do {
                let data = try JSONEncoder().encode(toDos)
                UserDefaults.standard.set(data, forKey: "ToDos")
            } catch {
                print("Failed to save ToDos: \(error)")
            }
        }
        
        // Load ToDos from UserDefaults or a file
        static func loadToDos() -> [ToDo]? {
            guard let data = UserDefaults.standard.data(forKey: "ToDos") else { return nil }
            do {
                let toDos = try JSONDecoder().decode([ToDo].self, from: data)
                return toDos
            } catch {
                print("Failed to load ToDos: \(error)")
                return nil
            }
        }
    
    static func loadSampleToDos() -> [ToDo] {
        let toDo1 = ToDo(title: "To-Do One", isComplete: false, dueDate: Date(), notes: "Notes 1")
        let toDo2 = ToDo(title: "To-Do Two", isComplete: false, dueDate: Date(), notes: "Notes 2")
        let toDo3 = ToDo(title: "To-Do Three", isComplete: false, dueDate: Date(), notes: "Notes 3")

        return [toDo1, toDo2, toDo3]
    }

    static func ==(lhs: ToDo, rhs: ToDo) -> Bool {
        return lhs.id == rhs.id
    }
}


