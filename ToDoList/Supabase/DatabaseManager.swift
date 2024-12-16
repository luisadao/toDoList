//
//  DatabaseManager.swift
//  SupabaseAuth
//
//  Created by User on 14/12/24.
//

import Foundation
import Supabase

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private init() {}
    
    let client = SupabaseClient(supabaseURL: URL(string: "https://spmbpijgqevqgrmtvmia.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNwbWJwaWpncWV2cWdybXR2bWlhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQzMDE3NjIsImV4cCI6MjA0OTg3Nzc2Mn0.PvLe2CzIT0j9nroRUi5ettaaxiuxIhChpCteqRsQOOc")

    // MARK: - CREATE a ToDo Item
    func createToDoItem(item: ToDo) async throws {
        print("Database Manager FIle")
        print(item)
        let response = try await client
            .from("todos")
            .insert(item)
            .execute()
        
        print(response)
        print(response.status)

            print("Inserted ToDo item: \(response.data)")

    }
    
    // MARK: - FETCH ToDo Items for a user
    func fetchToDoItems(for uid: String) async throws -> [ToDo] {
        let response = try await client
                .from("todos")
                .select("*")
                .eq("user_uid", value: uid)
                .order("created_at", ascending: true)
                .execute()

       let data = response.data

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .custom { decoder -> Date in
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)

                let formatter1 = ISO8601DateFormatter()
                if let date = formatter1.date(from: dateString) {
                    return date
                }

                let formatter2 = DateFormatter()
                formatter2.dateFormat = "yyyy-MM-dd"
                if let date = formatter2.date(from: dateString) {
                    return date
                }

                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format")
            }

            do {
                let todos = try decoder.decode([ToDo].self, from: data)
                print("Decoded ToDo objects: \(todos)")
                return todos
            } catch {
                print("Error decoding todos: \(error)")
                throw error
            }
    }


    
    // MARK: - DELETE a ToDo Item
    func deleteToDoItem(id: Int) async throws {
        let response = try await client
            .from("todos")
            .delete()
            .eq("id", value: id)
            .execute()
        
        print(response)
        print(response.status)
        //if let responseData = response.data {
        print("Deleted ToDo item: \(response.data)")
        //}
    }
}
