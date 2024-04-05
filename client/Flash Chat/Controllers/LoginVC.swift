//
//  LoginViewController.swift
//  Flash Chat
//
//  Created by Pichborith Kong on 4/2/24.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var userManager = UserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userManager.delegate = self
        
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let username = usernameTextField.text,
           let password = passwordTextField.text {
            userManager.loginUser(username: username, password: password)
        }
    }
    
}


// MARK: - UserLoaderDelegate

extension LoginVC : UserLoaderDelegate {
    
    func didUpdateUser(user: User) {
        DispatchQueue.main.async {
            UserDefaults.standard.setValue(user.username, forKey: "username")
            UserDefaults.standard.setValue(user.token, forKey: "token")
            self.performSegue(withIdentifier: K.Segue.LoginToChat, sender: self)
        }
        
    }
    
    func didFailWithError(error: any Error) {
        print(error.localizedDescription)
    }
    
}
