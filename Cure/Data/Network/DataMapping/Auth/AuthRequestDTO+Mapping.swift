//
//  AuthRequestDTO+Mapping.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

// MARK: - Data Transfer Object
struct LoginRequestDTO: Encodable {
    let username: String
    let password: String
}

struct RegisterRequestDTO: Encodable {
    let namaLengkap: String
    let username: String
    let password: String
}
