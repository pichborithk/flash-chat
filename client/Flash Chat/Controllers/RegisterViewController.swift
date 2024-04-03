//
//  RegisterViewController.swift
//  Flash Chat
//
//  Created by Pichborith Kong on 4/2/24.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func registerPressed(_ sender: UIButton) {
        //        if let email = emailTextfield.text,
        //           let password = passwordTextfield.text {
        //            Auth.auth().createUser(withEmail: email, password: password) {
        //                _, error in
        //                if let e = error {
        //                    print(e.localizedDescription)
        //                } else {
        //
        //                }
        //            }
        //        }
        self.performSegue(withIdentifier: K.registerSegue, sender: self)
    }

}
