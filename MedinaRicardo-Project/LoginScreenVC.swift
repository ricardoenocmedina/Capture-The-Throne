// Project: MedinaRicardo-Project
// EID: rem3885
// Course: CS329E
//
//  LoginScreenVC.swift
//  MedinaRicardo-Project
//
//  Created by Ricardo Medina on 4/28/25.
//

import UIKit
import FirebaseAuth

class LoginScreenVC: UIViewController {

    @IBOutlet weak var segCtrl: UISegmentedControl!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load Sign In at start
        button.setTitle("Sign In", for: .normal)
        
        // Hide confirm password and text field
        confirmPasswordLabel.isHidden = true
        confirmPasswordField.isHidden = true
        
        // encrypt password
        passwordField.isSecureTextEntry = true
        confirmPasswordField.isSecureTextEntry = true
    }
    
    @IBAction func ctrlSegPressed(_ sender: Any) {
        switch segCtrl.selectedSegmentIndex { // toggle between sign in and sign up
        case 0:
            confirmPasswordLabel.isHidden = true
            confirmPasswordField.isHidden = true
            button.setTitle("Sign In", for: .normal)
        case 1:
            confirmPasswordLabel.isHidden = false
            confirmPasswordField.isHidden = false
            button.setTitle("Sign Up", for: .normal)
        default:
            print("This should never run")
            break
        }
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        let email = emailField.text ?? ""
        let password = passwordField.text ?? ""
        
        switch button.title(for: .normal) {
        // sign in
        case "Sign In":
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                if let error = error as NSError? {
                    self.statusLabel.text = "Login failed: \(error.localizedDescription)"
                } else {
                    // Update Status Label after successful log in
                    self.statusLabel.text = ""
                    // Navigate to main screen (segue)
                    self.performSegue(withIdentifier: "authenticationSegue", sender: self)
                }
            }
            
        case "Sign Up":
            let confirmPassword = confirmPasswordField.text ?? ""
            
            // Validate Email
            if !isValidEmail(email) {
                statusLabel.text = "Invalid email format."
                return
            }
            // Validate Email length
            if !isValidPassword(email) {
                statusLabel.text = "Email must be at least 7 characters"
                return
            }
            // Validate Password Length
            if !isValidPassword(password) {
                statusLabel.text = "Password must be at least 7 characters."
                return
            }
            // Ensure Passwords Match
            if password != confirmPassword {
                statusLabel.text = "Passwords do not match."
                return
            }
            
            // sign up
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if let error = error as NSError? {
                    self.statusLabel.text = "Sign up failed: \(error.localizedDescription)"
                } else {
                    // Clear Status Label
                    self.statusLabel.text = ""
                    // Immediately log the user in once the account is created
                    Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                        if let error = error {
                            self.statusLabel.text = "Auto login failed: \(error.localizedDescription)"
                        } else {
                            // Perform segue to main view controller
                            self.performSegue(withIdentifier: "authenticationSegue", sender: self)
                        }
                    }
                }
            }
            
        default:
            print("This should never run")
            break
        }
    }
    
    // valid email check from code library
    func isValidEmail(_ email: String) -> Bool {
       let emailRegEx =
           "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
       let emailPred = NSPredicate(format:"SELF MATCHES %@",
           emailRegEx)
       return emailPred.evaluate(with: email)
    }
     
    // valid password check from code library
    func isValidPassword(_ password: String) -> Bool {
       let minPasswordLength = 6
       return password.count >= minPasswordLength
    }
}
