//
//  User.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 18/03/25.
//

struct User: Equatable, Identifiable {
    let id: String
    let username: String
    let email: String
    let role: UserResponseDTO.RoleDTO
    // Other User details here
}
