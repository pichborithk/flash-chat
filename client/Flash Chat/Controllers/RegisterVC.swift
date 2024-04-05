//
//  RegisterViewController.swift
//  Flash Chat
//
//  Created by Pichborith Kong on 4/2/24.
//

import UIKit

class RegisterVC: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var userManager = UserManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        userManager.delegate = self
    }
    

    @IBAction func registerPressed(_ sender: UIButton) {
        if let username = usernameTextField.text,
           let password = passwordTextField.text {
            userManager.registerUser(username: username, password: password)
        }
    }

}

// MARK: - UserLoaderDelegate

extension RegisterVC : UserLoaderDelegate {
    
    func didUpdateUser(user: User) {
        DispatchQueue.main.async {
            UserDefaults.standard.setValue(user.username, forKey: "username")
            UserDefaults.standard.setValue(user.token, forKey: "token")
            self.performSegue(withIdentifier: K.Segue.RegisterToChat, sender: self)
        }
        
    }
    
    func didFailWithError(error: any Error) {
        print(error.localizedDescription)
    }
    
}
