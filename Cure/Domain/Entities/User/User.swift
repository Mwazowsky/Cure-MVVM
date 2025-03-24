//
//  User.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 18/03/25.
//

struct User: Equatable {
    let user_id: String
    let email: String
    let expiredAt: Int
    let role: UserResponseDTO.RoleDTO
    let accessToken: String
}
