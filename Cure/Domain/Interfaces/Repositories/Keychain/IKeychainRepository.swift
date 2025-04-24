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
    
    func saveFCMTokenData(_ fcmToken: String) -> Bool
    func getFCMTokenData() -> String?
    func deleteFCMTokenData() -> Void
    
    // TODO: This should be stored in presistent core data storage
    func saveHandledContactData(_ value: [Int:[ChatContactResponseDTO]]) -> Bool
    func getHandledContactData() -> [Int:[ChatContactResponseDTO]]?
    func deleteHandledContactData() -> Void
}
