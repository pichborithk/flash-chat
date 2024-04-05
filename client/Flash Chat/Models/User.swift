//
//  User.swift
//  Flash Chat
//
//  Created by Pichborith Kong on 4/2/24.
//

import Foundation

struct UserRequest : Encodable {
    let username : String
    let password : String
}

struct UserResponse : Decodable {
    let success: Bool
    let data: User?
    let error : ErrorResponse?
}

struct User : Decodable {
    
    let username: String
    let token : String
    let statusMessage: String
    
}

protocol UserLoaderDelegate {
    func didUpdateUser(user: User)
    func didFailWithError(error: Error)
}


struct UserManager {
    
    var delegate: UserLoaderDelegate?
    
    func registerUser(username: String, password: String) {
        guard let url = URL(string: K.endpoint + "users/register") else { return }
        let body = UserRequest(username: username, password: password)
        let request = createRequest(url: url, body: body)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let safeData = data, error == nil else {
                self.delegate?.didFailWithError(error: error!)
                return
            }
           
            guard let responseData = self.parseJSON(safeData) else { return }
            
            if let user = responseData.data {
                self.delegate?.didUpdateUser(user: user)
            } else {
                print(responseData.error!.message)
            }
            
            
        }.resume()
    }
    
    func loginUser(username: String, password: String) {
        guard let url = URL(string: K.endpoint + "users/login") else { return }
        let body = UserRequest(username: username, password: password)
        let request = createRequest(url: url, body: body)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let safeData = data, error == nil else {
                self.delegate?.didFailWithError(error: error!)
                return
            }
           
            guard let responseData = self.parseJSON(safeData) else { return }
            
            if let user = responseData.data {
                self.delegate?.didUpdateUser(user: user)
            } else {
                print(responseData.error!.message)
            }
            
            
        }.resume()

    }
    
    private func createRequest(url: URL, body: Encodable) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            delegate?.didFailWithError(error: error)
        }
        
        return request
    }
    
    private func parseJSON(_ data: Data) -> UserResponse? {
        do {
            let responseData = try JSONDecoder().decode(UserResponse.self, from: data)
            return responseData
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
