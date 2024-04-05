//
//  Message.swift
//  Flash Chat
//
//  Created by Pichborith Kong on 4/2/24.
//

import Foundation

struct MessageRequest : Encodable {
    let text: String
}

struct MessageResponse : Decodable {
    let success: Bool
    let data: Message?
    let error : ErrorResponse?
}

struct MessagesResponse : Decodable {
    let success: Bool
    let data: [Message]?
    let error : ErrorResponse?
}

struct Message : Decodable {
    let id: Int
    let sender: String
    let text: String
    
}

protocol MessageManagerDelegete {
    func didPostMessage(_ message: Message)
    func didGetMessages(_ messages: [Message])
    func didFailWithError(_ error: Error)
}

struct MessageManager {
    
    var delegate: MessageManagerDelegete?
    
    func getMessages(token: String) {
        guard let url = URL(string: K.endpoint + "/api/messages") else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let safeData = data, error == nil else {
                self.delegate?.didFailWithError(error!)
                return
            }
            
            guard let responseData: MessagesResponse = self.parseJSON(safeData) else { return }
            
            if let messages = responseData.data {
                self.delegate?.didGetMessages(messages)
            } else {
                self.delegate?.didFailWithError(error!)
            }
            
            
        }.resume()
    }
    
    func postMesssage(text: String, token: String) {
        guard let url = URL(string: K.endpoint + "/api/messages") else { return }
        let body = MessageRequest(text: text)
        let request = createRequest(url: url, token: token, body: body)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let safeData = data, error == nil else {
                self.delegate?.didFailWithError(error!)
                return
            }
            
            guard let responseData: MessageResponse = self.parseJSON(safeData) else { return }
            
            if let message = responseData.data {
                self.delegate?.didPostMessage(message)
            } else {
                self.delegate?.didFailWithError(error!)
            }
            
            
        }.resume()
    }
    
    
    private func createRequest(url: URL, token: String, body: Encodable) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            self.delegate?.didFailWithError(error)
        }
        
        return request
    }
    
    private func parseJSON<T: Decodable>(_ data: Data) -> T? {
        do {
            let responseData = try JSONDecoder().decode(T.self, from: data)
            return responseData
        } catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
}
