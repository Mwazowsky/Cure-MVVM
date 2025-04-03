//
//  TokenManager.swift
//  Cure
//
//  Created by MacBook Air MII  on 3/4/25.
//

class TokenManager {
    static let shared = TokenManager()
    
    private var token: String?
    
    func configure(token: String) {
        self.token = token
    }
    
    func getToken() -> String {
        if let userToken = token {
            return userToken
        }
        return ""
    }
}
