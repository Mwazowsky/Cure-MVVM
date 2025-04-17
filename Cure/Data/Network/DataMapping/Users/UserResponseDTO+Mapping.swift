//
//  UserResponseDTO+Mapping.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation
import CoreData

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

extension UserDetailsResponse.ErrorDetail {
    func toEntity(in context: NSManagedObjectContext) -> ErrorEntity {
        let entity = ErrorEntity(context: context)
        entity.name = name
        entity.detail = detail
        return entity
    }
}

extension UserDetailsResponse {
    func toEntity(in context: NSManagedObjectContext) -> UserBaseResponseEntity {
            let entity = UserBaseResponseEntity(context: context)
            
            entity.status = Int16(status)
            entity.message = message
            entity.errors = (errors as [String]).joined(separator: ", ")
            entity.success = success
            
            if let error = error {
                entity.error = error.toEntity(in: context)
            }
            
            if let data = data {
                entity.data = data.toEntitiy(in: context)
            }
            
            return entity
        }
    
    func toDomain() -> UserDetailsResponse {
        return .init(
            status: Int(status),
            message: message,
            errors: errors,
            error: error,
            success: success,
            data: data
        )
    }
}

extension UserDetailsDTO {
    func toEntitiy(in context: NSManagedObjectContext) -> UserDetailsResponseEntity {
        let entity: UserDetailsResponseEntity = .init(context: context)
        entity.employeeID = Int64(employeeID)
        entity.companyId = Int64(companyID)
        entity.companyName = companyName
        entity.name = name
        entity.email = email
        entity.dob = dob
        entity.gender = gender
        entity.address = address
        entity.phoneNumber = phoneNumber
        entity.nationality = nationality
        entity.photoURL = photoURL
        entity.isOnline = isOnline
        entity.lastOnline = lastOnline
        entity.sundayStart = sundayStart
        entity.sundayEnd = sundayEnd
        entity.mondayStart = mondayStart
        entity.mondayEnd = mondayEnd
        entity.tuesdayStart = tuesdayStart
        entity.tuesdayEnd = tuesdayEnd
        entity.wednesdayStart = wednesdayStart
        entity.wednesdayEnd = wednesdayEnd
        entity.thursdayStart = thursdayStart
        entity.thursdayEnd = thursdayEnd
        entity.fridayStart = fridayStart
        entity.fridayEnd = fridayEnd
        entity.saturdayStart = saturdayStart
        entity.saturdayEnd = saturdayEnd
        entity.avgResponseTime = Int64(avgResponseTime)
        entity.weeklyScore = weeklyScore
        
        return entity
    }
    
    func toDomain() -> UserDetailsDTO {
        return .init(
            employeeID: Int(employeeID),
            companyID: Int(companyID),
            companyName: companyName,
            name: name,
            email: email,
            dob: dob,
            gender: gender,
            address: address,
            phoneNumber: phoneNumber,
            nationality: nationality,
            photoURL: photoURL,
            isOnline: isOnline,
            lastOnline: lastOnline,
            sundayStart: sundayStart,
            sundayEnd: sundayEnd,
            mondayStart: mondayStart,
            mondayEnd: mondayEnd,
            tuesdayStart: tuesdayStart,
            tuesdayEnd: tuesdayEnd,
            wednesdayStart: wednesdayStart,
            wednesdayEnd: wednesdayEnd,
            thursdayStart: thursdayStart,
            thursdayEnd: thursdayEnd,
            fridayStart: fridayStart,
            fridayEnd: fridayEnd,
            saturdayStart: saturdayStart,
            saturdayEnd: saturdayEnd,
            avgResponseTime: Int(avgResponseTime),
            weeklyScore: weeklyScore
        )
    }
}
