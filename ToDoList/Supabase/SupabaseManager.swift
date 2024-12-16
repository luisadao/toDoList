//
//  SupabaseManager.swift
//  ToDoList
//
//  Created by User on 15/12/2024.
//

import Supabase
import Foundation

class SupabaseManager {
    static let shared = SupabaseManager()
    
    private let client: SupabaseClient
    
    private init() {
        let supabaseUrl = URL(string: "https://spmbpijgqevqgrmtvmia.supabase.co")!
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNwbWJwaWpncWV2cWdybXR2bWlhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQzMDE3NjIsImV4cCI6MjA0OTg3Nzc2Mn0.PvLe2CzIT0j9nroRUi5ettaaxiuxIhChpCteqRsQOOc"
        self.client = SupabaseClient(supabaseURL: supabaseUrl, supabaseKey: supabaseKey)
    }
    
    func getClient() -> SupabaseClient {
        return client
    }
}
