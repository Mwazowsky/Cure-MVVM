//
//  AuthResponseDTO+Mapping.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

struct LoginResponse: Decodable {
    let status: Int
    let message: String
    let errors: [String]
    let error: ErrorDetail?
    let success: Bool
    let data: LoginResponseDTO?
    
    struct ErrorDetail: Decodable {
        let name: String
        let detail: String
    }
}

struct MetaData: Decodable {
    let page: Int
    let size: Int
    let totalData: Int
    let totalPages: Int
}

struct LoginResponseDTO: Codable {
    private enum CodingKeys: String, CodingKey {
        case token = "token"
    }
    
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
