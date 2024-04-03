//
//  RegisterViewController.swift
//  Flash Chat
//
//  Created by Pichborith Kong on 4/2/24.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var userLoader = UserLoader()

    override func viewDidLoad() {
        super.viewDidLoad()

        userLoader.delegate = self
    }
    

    @IBAction func registerPressed(_ sender: UIButton) {
        if let username = usernameTextField.text,
           let password = passwordTextField.text {
            userLoader.registerUser(username: username, password: password)
        }
    }

}

// MARK: - UserLoaderDelegate

extension RegisterViewController : UserLoaderDelegate {
    
    func didUpdateUser(user: User) {
        DispatchQueue.main.async {
            UserDefaults.standard.setValue(user.username, forKey: "username")
            self.performSegue(withIdentifier: K.Segue.RegisterToChat, sender: self)
        }
        
    }
    
    func didFailWithError(error: any Error) {
        print(error.localizedDescription)
    }
    
}
