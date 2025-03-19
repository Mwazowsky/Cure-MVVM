//
//  AuthResponseDTO+Mapping.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

struct LoginResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case email
        case role = "role"
        case token = "jwt_token"
    }
    
    let id: String
    let email: String
    let role: UserResponseDTO.RoleDTO
    let token: String
}

struct RegisterResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case username, email, password
        case role = "role"
    }
    
    let id: String
    let username: String
    let email: String
    let password: String
    let role: UserResponseDTO.RoleDTO
}
