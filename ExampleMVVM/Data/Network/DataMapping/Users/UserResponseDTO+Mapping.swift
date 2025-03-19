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
        case id = "id"
        case username, email
        case role = "role"
    }
    enum RoleDTO: String, Decodable {
        case admin = "ADMIN"
        case staff = "STAFF"
    }
    let id: String
    let username: String
    let email: String
    let role: RoleDTO
    // Other User details from api response here
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
