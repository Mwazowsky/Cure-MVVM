//
//  UserResponseDTO+Mapping.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

// MARK: - Data Transfer Object

struct UserDetailsDTO: Codable {
    let employeeID, companyID: Int
    let companyName, name, email: String
    let dob, gender, address: String?
    let phoneNumber: String?
    let nationality: String?
    let photoURL: String?
    let isOnline: Bool
    let lastOnline: String
    let sundayStart, sundayEnd, mondayStart, mondayEnd: String?
    let tuesdayStart, tuesdayEnd, wednesdayStart, wednesdayEnd: String?
    let thursdayStart, thursdayEnd, fridayStart, fridayEnd: String?
    let saturdayStart: String?
    let saturdayEnd: String?
    let avgResponseTime: Int
    let weeklyScore: Double
    
    enum CodingKeys: String, CodingKey {
        case employeeID, companyID, companyName, name, email, dob, gender, address, phoneNumber, nationality
        case photoURL = "photoUrl"
        case isOnline, lastOnline, sundayStart, sundayEnd, mondayStart, mondayEnd, tuesdayStart, tuesdayEnd, wednesdayStart, wednesdayEnd, thursdayStart, thursdayEnd, fridayStart, fridayEnd, saturdayStart, saturdayEnd
        case avgResponseTime, weeklyScore
    }
    
    func getMinuteResponseTime() -> Double {
        let milis = Double(self.avgResponseTime)
        
        if milis == 0 {
            return 0.0
        }
        
        return milis / 60000
    }
}

struct UserDetailsResponse: Decodable {
    let status: Int
    let message: String
    let errors: [String]
    let error: ErrorDetail?
    let success: Bool
    let data: UserDetailsDTO?
    
    struct ErrorDetail: Decodable {
        let name: String
        let detail: String
    }
}
