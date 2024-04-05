//
//  ChatViewController.swift
//  Flash Chat
//
//  Created by Pichborith Kong on 4/2/24.
//

import UIKit

class ChatVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var messages:[Message] = []
    var messageManager = MessageManager()
    var socketIOManagaer = SocketIOManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = K.appName
        navigationItem.hidesBackButton = true
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        messageManager.delegate = self
        if let token = UserDefaults.standard.string(forKey: "token") {
            self.messageManager.getMessages(token: token)
        }
        
        socketIOManagaer.delegate = self
   
        socketIOManagaer.setupSocketEvents()
        socketIOManagaer.establishConnection()
    }
    
    func loadMessages() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            self.messageTextfield.text = ""
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let text = messageTextfield.text,
           let token = UserDefaults.standard.string(forKey: "token") {
            messageManager.postMesssage(text: text, token: token)
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "token")
        socketIOManagaer.closeConnection()
    }
    
}


// MARK: - UITableViewDataSource

extension ChatVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.text
        let username = UserDefaults.standard.string(forKey: "username")
        
        if message.sender == username {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        return cell
    }
}

// MARK: - MessageManagerDelegate

extension ChatVC : MessageManagerDelegete {
    func didPostMessage(_ message: Message) {
        messages.append(message)
        loadMessages()
        socketIOManagaer.emit(event: "message", data: message)
    }
    
    func didGetMessages(_ messages: [Message]) {
        self.messages = messages
        loadMessages()
    }
    
    func didFailWithError(_ error: any Error) {
        print(error.localizedDescription)
    }
    
    
}

// MARK: - SocketIOManagerDelegate

extension ChatVC : SocketIOManagerDelegete {
    
    func didUpdateMessage(_ message: Message) {
        print("SocketIO Managaer Delegete Trigger")
        let username = UserDefaults.standard.string(forKey: "username")
        if username != message.sender {
            messages.append(message)
            loadMessages()
        }
    }
    
}
