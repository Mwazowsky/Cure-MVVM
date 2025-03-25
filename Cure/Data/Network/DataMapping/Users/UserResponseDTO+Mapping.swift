//
//  UserResponseDTO+Mapping.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

// MARK: - Data Transfer Object

struct UserResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case email = "email"
        case expiredAt = "expiredAt"
        case role = "role"
        case token = "accessToken"
    }
    
    enum RoleDTO: String, Decodable {
        case admin = "ADMINISTRATOR"
        case staff = "STAFF"
    }
    
    let email: String
    let expiredAt: Int
    let role: RoleDTO
    let token: String
}

// MARK: - Private

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
}()
