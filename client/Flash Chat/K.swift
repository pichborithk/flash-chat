//
//  Constants.swift
//  Flash Chat
//
//  Created by Pichborith Kong on 4/2/24.
//

import Foundation

struct K {
    static let appName = "⚡️FlashChat"
    
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    
    static let endpoint = "http://localhost:1337/api/"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
}
