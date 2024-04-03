//
//  ChatViewController.swift
//  Flash Chat
//
//  Created by Pichborith Kong on 4/2/24.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var messages: [Message] = [
        Message(sender: "1@2.com", body: "Hey!"),
        Message(sender: "2@2.com", body: "Hello")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let token = UserDefaults.standard.string(forKey: "token") {
            print(token)
        }
        
        title = K.appName
        navigationItem.hidesBackButton = true
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        //        loadMessages()
    }
    
    func loadMessages() {
        //        db.collection(Constants.FStore.collectionName).order(by: Constants.FStore.dateField).addSnapshotListener {
        //                querySnapshot, error in
        //                self.messages = []
        //
        //                if let e = error {
        //                    print("There was an issue retrieving data from firestore, \(e)")
        //
        //                } else {
        //                    if let snapShotDocuments = querySnapshot?.documents {
        //                        for document in snapShotDocuments {
        //                            let data = document.data()
        //                            if let messageSender = data[Constants.FStore.senderField] as? String,
        //                               let messageBody = data[Constants.FStore.bodyField] as? String
        //                            {
        //                                let newMessage = Message(sender: messageSender, body: messageBody)
        //                                self.messages.append(newMessage)
        //
        //                                DispatchQueue.main.async {
        //                                    self.tableView.reloadData()
        //                                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
        //                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        //                                }
        //                            }
        //                        }
        //                    }
        //                }
        //            }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        //        if let messageBody = messageTextfield.text,
        //           let messageSender = Auth.auth().currentUser?.email {
        //            db.collection(Constants.FStore.collectionName)
        //                .addDocument(data: [
        //                    Constants.FStore.senderField: messageSender,
        //                    Constants.FStore.bodyField: messageBody,
        //                    Constants.FStore.dateField: Date().timeIntervalSince1970]) {
        //                        error in
        //                        if let e = error {
        //                            print("There was an issue saving data to firestore, \(e)")
        //                        } else {
        //                            print("Successfully saved data.")
        //                            DispatchQueue.main.async {
        //                                self.messageTextfield.text = ""
        //                            }
        //                        }
        //                    }
        //        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "token")
    }
    
}


// MARK: - UITableViewDataSource

extension ChatViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body
        
        //        if message.sender == Auth.auth().currentUser?.email {
        //            cell.leftImageView.isHidden = true
        //            cell.rightImageView.isHidden = false
        //            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.lightPurple)
        //            cell.label.textColor = UIColor(named: Constants.BrandColors.purple)
        //        } else {
        //            cell.leftImageView.isHidden = false
        //            cell.rightImageView.isHidden = true
        //            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.purple)
        //            cell.label.textColor = UIColor(named: Constants.BrandColors.lightPurple)
        //        }
        
        return cell
    }
}
