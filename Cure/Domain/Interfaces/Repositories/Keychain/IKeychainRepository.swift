//
//  UsersRepository.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

/// REFACTOR DTO to DM: Dont use DTO model in this, since its shouldnt directly work upon the data from the api
protocol IKeychainRepository {
    func saveLoginTokenData(_ token: LoginResponseDTO) -> Bool
    func getLoginTokenData() -> LoginResponseDTO?
    func deleteLoginTokenData() -> Void
    
    /// CORRECT DTO to Domain Model(DM): This is the correct implementation
    /// DM only contains handpicked value of DTOs, and is seperate model for more seperation and decoupling
    func saveUserDetailsData(_ userData: UserDetailsDM) -> Bool
    func getUserDetailsData() -> UserDetailsDM?
    func deleteUserDetailsData() -> Void
    
    func saveFCMTokenData(_ fcmToken: String) -> Bool
    func getFCMTokenData() -> String?
    func deleteFCMTokenData() -> Void
    
    func saveHandledContactData(_ value: [Int:[ChatContactDTO]]) -> Bool
    func getHandledContactData() -> [Int:[ChatContactDTO]]?
    func deleteHandledContactData() -> Void
}
