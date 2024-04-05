//
//  Constants.swift
//  Flash Chat
//
//  Created by Pichborith Kong on 4/2/24.
//

import Foundation

struct K {
    static let appName = "⚡️FlashChat"
    
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    
    //    static let endpoint = "http://localhost:1337/api/"
    //    using IP instead of localhost to remove warning
    static let endpoint = "http://127.0.0.1:1337/api/"
    
    struct Segue {
        static let WelcomeToLogin = "WelcomeToLogin"
        static let WelcomeToRegister = "WelcomeToRegister"
        static let RegisterToChat = "RegisterToChat"
        static let LoginToChat = "LoginToChat"
    }
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
}
