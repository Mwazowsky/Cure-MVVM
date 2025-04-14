//
//  UsersRepository.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

protocol IKeychainRepository {
    func saveUserTokenData(_ userData: LoginResponseDTO) -> Bool
    func getUserTokenData() -> LoginResponseDTO?
    func deleteUserTokenData() -> Void
    
    func saveUserDetailsData(_ userData: UserDetailsDTO) -> Bool
    func getUserDetailsData() -> UserDetailsDTO?
    func deleteUserDetailsData() -> Void
    
    func saveFCMTokenData(_ fcmToken: String) -> Bool
    func getFCMTokenData() -> String?
    func deleteFCMTokenData() -> Void
    
    func saveHandledContactData(_ value: [Int:[ChatContact]]) -> Bool
    func getHandledContactData() -> [Int:[ChatContact]]?
    func deleteHandledContactData() -> Void
}
