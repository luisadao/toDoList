//
//  ToDo.swift
//  ToDo
//

import Foundation
import Supabase

struct ToDo: Equatable, Codable {
    let id: Int?  
    var title: String
    var isComplete: Bool
    var createdAt: Date?
    var dueDate: Date?
    var notes: String?
    var userUid: String
    
    
    init(title: String, isComplete: Bool, dueDate: Date, notes: String?, userUid: String, id: Int? = nil) {
        self.id = id
        self.createdAt = Date.now
        self.title = title
        self.isComplete = isComplete
        self.dueDate = dueDate
        self.notes = notes
        self.userUid = userUid
    }

    enum CodingKeys: String, CodingKey {
            case id
            case createdAt = "created_at"  // Matching field names in JSON
            case isComplete = "isComplete"
            case title
            case dueDate = "dueDate"
            case notes
            case userUid = "user_uid"  // This is the key in JSON
        }
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            id = try container.decode(Int.self, forKey: .id)
            
            if let createdAtString = try container.decodeIfPresent(String.self, forKey: .createdAt) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS+00:00"
                createdAt = dateFormatter.date(from: createdAtString)
            }
            
            isComplete = try container.decode(Bool.self, forKey: .isComplete)
            title = try container.decode(String.self, forKey: .title)
            
            // Custom date decoding for `dueDate`
            if let dueDateString = try container.decodeIfPresent(String.self, forKey: .dueDate) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dueDate = dateFormatter.date(from: dueDateString)
            }
            
            notes = try container.decode(String.self, forKey: .notes)
        userUid = try container.decode(String.self, forKey: ToDo.CodingKeys(rawValue: "user_uid")!)
        }
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("toDos").appendingPathExtension("plist")
    
    static func saveToDos(_ toDos: [ToDo]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedToDos = try? propertyListEncoder.encode(toDos)
        try? codedToDos?.write(to: archiveURL, options: .noFileProtection)
    }
    
    static func loadToDos() -> [ToDo]? {
        guard let codedToDos = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode([ToDo].self, from: codedToDos)
    }
    
    static func ==(lhs: ToDo, rhs: ToDo) -> Bool {
        return lhs.id == rhs.id
    }

    // MARK: CREATE
    static func createToDo(title: String, isComplete: Bool, dueDate: Date, notes: String?, userId: String) async throws {
        let toDo = ToDo(title: title, isComplete: isComplete, dueDate: dueDate, notes: notes, userUid: userId.lowercased())
        print("Creating ToDo: \(toDo)")
        try await DatabaseManager.shared.createToDoItem(item: toDo)
    }

    // MARK: READ
    func fetchTodos(forUid: String) async throws -> [ToDo] {
        
        return try await DatabaseManager.shared.fetchToDoItems(for: forUid)
            
            
    }

    // MARK: DELETE
    func deleteToDoItem(forId: Int) async throws {
        return try await DatabaseManager.shared.deleteToDoItem(id: forId)
    }
}
