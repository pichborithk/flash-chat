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

struct Message : Decodable {
    let id: Int
    let sender: String
    let text: String
    
}

struct MessageLoader {
    
    func postMesssage(text: String, token: String) {
        guard let url = URL(string: K.endpoint + "messages") else { return }
        let body = MessageRequest(text: text)
        let request = createRequest(url: url, token: token, body: body)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let safeData = data, error == nil else {
                //                self.delegate?.didFailWithError(error: error!)
                print(error!.localizedDescription)
                return
            }
            
            guard let responseData = self.parseJSON(safeData) else { return }
            
            if let message = responseData.data {
                //                self.delegate?.didUpdateUser(user: user)
                print(message.sender)
                print(message.text)
            } else {
                print(responseData.error!.message)
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
            //            delegate?.didFailWithError(error: error)
            print(error.localizedDescription)
        }
        
        return request
    }
    
    private func parseJSON(_ data: Data) -> MessageResponse? {
        do {
            let responseData = try JSONDecoder().decode(MessageResponse.self, from: data)
            return responseData
        } catch {
            //            delegate?.didFailWithError(error: error)
            print(error.localizedDescription)
            return nil
        }
    }
}
