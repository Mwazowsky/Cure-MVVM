//
//  User.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 18/03/25.
//

/// The DTO Reference
/// employeeID, companyID: Int
/// companyName, name, email: String
/// dob, gender, address: String?
/// phoneNumber: String?
/// nationality: String?
/// photoURL: String?
/// isOnline: Bool
/// lastOnline: String
/// sundayStart, sundayEnd, mondayStart, mondayEnd: String?
/// tuesdayStart, tuesdayEnd, wednesdayStart, wednesdayEnd: String?
/// thursdayStart, thursdayEnd, fridayStart, fridayEnd: String?
/// saturdayStart: String?
/// saturdayEnd: String?
/// avgResponseTime: Int
/// weeklyScore: Double



struct UserDetailsDM: Equatable, Codable {
    let employeeID, companyID: Int
    let dob, gender, address: String?
    let companyName, name, email: String
    let phoneNumber: String?
    
}
