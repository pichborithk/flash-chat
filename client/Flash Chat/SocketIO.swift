//
//  SocketIO.swift
//  Flash Chat
//
//  Created by Pichborith Kong on 4/4/24.
//

import Foundation

import SocketIO

//class SocketIOManager {
//    static let shared = SocketIOManager()
//
//    private var manager: SocketManager!
//    private var socket: SocketIOClient!
//
//    private init() {
//        manager = SocketManager(socketURL: URL(string: K.endpoint)!, config: [.log(true), .compress])
//        socket = manager.defaultSocket
//
//        setupSocketEvents()
//    }
//
//    func establishConnection() {
//        socket.connect()
//    }
//
//    func closeConnection() {
//        socket.disconnect()
//    }
//
//    private func setupSocketEvents() {
//        socket.on(clientEvent: .connect) { data, ack in
//            print("Socket connected")
//        }
//
//        socket.on("message") { data, ack in
//            if let dataArray = data[0] as? [String: Any], let updatedData = dataArray["data"] as? String {
//                // Handle updated data
//                print("Received updated data: \(updatedData)")
//
//                // Update UI or perform other tasks with the updated data
//            }
//        }
//    }
//}

protocol SocketIOManagerDelegete {
    func didUpdateMessage(_ message: Message)
}

struct SocketIOManager {
    
    var delegate: SocketIOManagerDelegete?
    
    private var manager: SocketManager
    private var socket: SocketIOClient
    
    public init() {
        manager = SocketManager(socketURL: URL(string: K.endpoint)!, config: [.log(true), .compress])
        socket = manager.defaultSocket
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func emit<T: Decodable>(event: String, data: T) {
        let mirror = Mirror(reflecting: data)
        var dict: [String: Any] = [:]
        for child in mirror.children {
            if let key = child.label {
                dict[key] = child.value
            }
        }
        
        socket.emit(event, dict)
    }
    
    func setupSocketEvents() {
        socket.on(clientEvent: .connect) { data, ack in
            print("Socket connected")
        }
        
        socket.on("message") { data, ack in
            guard let receivedData = data[0] as? [String: Any] else { return }
            //            print(receivedData)
            
            if let text = receivedData["text"] as? String,
               let sender = receivedData["sender"] as? String,
               let id = receivedData["id"] as? Int {
                let message = Message(id: id, sender: sender, text: text)
                self.delegate?.didUpdateMessage(message)
            }
        }
    }
}
