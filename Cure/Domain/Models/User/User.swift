//
//  User.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 18/03/25.
//

struct UserDetailsDM: Equatable, Codable {
    let employeeID, companyID: Int
    let dob, gender, address: String?
    let companyName, name, email: String
}

