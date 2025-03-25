//
//  AuthResponseDTO+Mapping.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

struct LoginResponse: Decodable {
    let message: String
    let code: Int
    let meta: MetaData
    let data: LoginResponseDTO
    let path: String
}

struct MetaData: Decodable {
    let page: Int
    let size: Int
    let totalData: Int
    let totalPages: Int
}

struct LoginResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email = "email"
        case expiredAt = "expiredAt"
        case role = "role"
        case token = "accessToken"
    }
    
    let userId: String
    let email: String
    let expiredAt: Int
    let role: UserResponseDTO.RoleDTO
    let token: String
}

struct RegisterResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case username, namaLengkap, password
        case role = "role"
    }
    
    let id: String
    let username: String
    let namaLengkap: String
    let password: String
    let role: UserResponseDTO.RoleDTO
}
