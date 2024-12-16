//
//  LoginViewController.swift
//  ToDoList
//
//  Created by User on 15/12/2024.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func loginUser(_ sender: Any) {
        // Safely unwrap email and password text fields
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(title: "Input Error", message: "Please enter a valid email.")
            return
        }

        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Input Error", message: "Please enter a password.")
            return
        }

        Task { @MainActor in
            do {

                let result = try await AuthManager.shared.signIn(email: email, password: password)

                print("User logged in successfully: \(result)")
                

                self.performSegue(withIdentifier: "toToDoList", sender: self)

            } catch {
                // Handle the error
                print("Failed to login user: \(error.localizedDescription)")
                

                showAlert(title: "Login Error", message: error.localizedDescription)
            }
        }
    }

    
    
    @IBAction func registerUser(_ sender: Any) {
        // Safely unwrap email and password text fields
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(title: "Input Error", message: "Please enter a valid email.")
            return
        }

        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Input Error", message: "Please enter a password.")
            return
        }

        Task { @MainActor in
            do {
                // Attempt to register the user
                let result = try await AuthManager.shared.registerNewUser(email: email, password: password)
                // Handle success, e.g., navigate to a new screen or display a success message
                print("User registered successfully: \(result)")
                
                // Optionally, show success alert or navigate
                self.performSegue(withIdentifier: "toToDoList", sender: self)

                //showAlert(title: "Success", message: "Registration successful!")
            } catch {
                // Handle the error
                print("Failed to register user: \(error.localizedDescription)")
                
                // Optionally, show an alert to the user
                showAlert(title: "Registration Error", message: error.localizedDescription)
            }
        }
    }

    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    


    
}
