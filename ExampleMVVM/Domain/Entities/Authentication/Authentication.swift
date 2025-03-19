//
//  AuthenticationError.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 18/03/25.
//

enum AuthenticationError: Error {
    case invalidCredentials
    case networkFailure
    case emailAlreadyExist
    case weakPassword
    case serverError(String)
    case unknownError
}

struct LoginResponse {
    let id: String
    let email: String
    let role: UserResponseDTO.RoleDTO
    let token: String
}


struct RegisterResponse {
    let id: String
    let username: String
    let email: String
    let password: String
    let role: UserResponseDTO.RoleDTO?
}
