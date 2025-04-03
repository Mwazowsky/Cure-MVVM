//
//  AuthRequestDTO+Mapping.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

// MARK: - Data Transfer Object
struct LoginRequestDTO: Encodable {
    let email: String
    let password: String
    let metadata: LoginMetadataDTO?
}

struct RegisterRequestDTO: Encodable {
    let namaLengkap: String
    let email: String
    let password: String
}

struct LoginMetadataDTO: Encodable {
    let platform: String
    let version: String
    let manufacturer: String
    let model: String
    let serial: String
    let fcmToken: String
}
