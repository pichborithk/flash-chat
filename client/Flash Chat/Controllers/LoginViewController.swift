//
//  LoginViewController.swift
//  Flash Chat
//
//  Created by Pichborith Kong on 4/2/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var userLoader = UserLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userLoader.delegate = self
        
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let username = usernameTextField.text,
           let password = passwordTextField.text {
            userLoader.loginUser(username: username, password: password)
        }
    }
    
}


// MARK: - UserLoaderDelegate

extension LoginViewController : UserLoaderDelegate {
    
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
