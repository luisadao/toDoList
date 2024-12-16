//
//  AuthManager.swift
//  ToDoList
//
//  Created by User on 15/12/2024.
//

import Foundation
import Supabase

struct AppUser {
    let uid: String
    let email: String?
}

class AuthManager{

    static let shared = AuthManager()
    
    private init(){}
    
    let client = SupabaseClient(supabaseURL: URL(string: "https://spmbpijgqevqgrmtvmia.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNwbWJwaWpncWV2cWdybXR2bWlhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQzMDE3NjIsImV4cCI6MjA0OTg3Nzc2Mn0.PvLe2CzIT0j9nroRUi5ettaaxiuxIhChpCteqRsQOOc")
    
    
        
        func getCurrentSession() async throws -> AppUser {
            let session = try await client.auth.session
           // print(session)
            print(session.user.id.uuidString.lowercased())
            return AppUser(uid: session.user.id.uuidString.lowercased(), email: session.user.email)
        }
        
        // MARK: Register
        func registerNewUser(email: String, password: String) async throws -> AppUser {
            let regAuthResponse = try await client.auth.signUp(email: email, password: password)
            guard let session = regAuthResponse.session else {
                print("no session when registering user")
                throw NSError()
            }
            return AppUser(uid: session.user.id.uuidString.lowercased(), email: session.user.email)
        }
        

        // MARK: Sign In
        func signIn(email: String, password: String) async throws -> AppUser {
            let session = try await client.auth.signIn(email: email, password: password)
            return AppUser(uid: session.user.id.uuidString.lowercased(), email: session.user.email)
            
        }
    
    func signOut() async throws {
        try await client.auth.signOut()
    }
}
