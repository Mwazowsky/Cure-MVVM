//
//  UserResponseDTO+Mapping.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

// MARK: - Data Transfer Object

struct UserDetailsDTO: Codable {
    private enum CodingKeys: String, CodingKey {
        case employeeID = "employeeID"
        case companyID = "companyID"
        case companyName = "companyName"
        case name = "name"
        case email = "email"
        case dob = "dob"
        case gender = "gender"
        case address = "address"
        case phoneNumber = "phoneNumber"
        case nationality = "nationality"
        case photoURL = "photoUrl"
        case isOnline = "isOnline"
        case lastOnline = "lastOnline"
        case sundayStart = "sundayStart"
        case sundayEnd = "sundayEnd"
        case mondayStart = "mondayStart"
        case mondayEnd = "mondayEnd"
        case tuesdayStart = "tuesdayStart"
        case tuesdayEnd = "tuesdayEnd"
        case wednesdayStart = "wednesdayStart"
        case wednesdayEnd = "wednesdayEnd"
        case thursdayStart = "thursdayStart"
        case thursdayEnd = "thursdayEnd"
        case fridayStart = "fridayStart"
        case fridayEnd = "fridayEnd"
        case saturdayStart = "saturdayStart"
        case saturdayEnd = "saturdayEnd"
        case avgResponseTime = "avgResponseTime"
        case weeklyScore = "weeklyScore"
    }
    
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
