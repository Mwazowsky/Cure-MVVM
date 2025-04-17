//
//  UserDetailsResponseEntityMapping.swift
//  Cure
//
//  Created by MacBook Air MII  on 16/4/25.
//

import Foundation
import CoreData

extension UserDetailsResponseEntity {
    func toDTO() -> UserDetailsDTO {
        return .init(
            employeeID: Int(employeeID),
            companyID: Int(companyId),
            companyName: companyName ?? "-",
            name: name ?? "-",
            email: email ?? "-",
            dob: dob,
            gender: gender,
            address: address,
            phoneNumber: phoneNumber,
            nationality: nationality,
            photoURL: photoURL,
            isOnline: Bool(isOnline),
            lastOnline: lastOnline ?? "-",
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

extension ErrorEntity {
    func toDTO() -> UserDetailsResponse.ErrorDetail {
        return UserDetailsResponse.ErrorDetail(
            name: name ?? "",
            detail: detail ?? ""
        )
    }
}

extension UserBaseResponseEntity {
    func toDTO() -> UserDetailsResponse {
        return UserDetailsResponse(
            status: Int(status),
            message: message ?? "",
            errors: errors?.components(separatedBy: ", ") ?? [],
            error: error?.toDTO(),
            success: success,
            data: data?.toDTO()
        )
    }
}
