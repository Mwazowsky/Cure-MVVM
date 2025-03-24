//
//  AuthenticationError.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 18/03/25.
//

enum AuthenticationError: Error {
    case invalidCredentials
    case networkFailure
    case usernameAlreadyExist
    case weakPassword
    case serverError(String)
    case unknownError
}

struct LoginResponse {
    let id: String
    let username: String
    let role: UserResponseDTO.RoleDTO
    let token: String
}


struct RegisterResponse {
    let id: String
    let username: String
    let namaLengkap: String
    let password: String
    let role: UserResponseDTO.RoleDTO?
}
