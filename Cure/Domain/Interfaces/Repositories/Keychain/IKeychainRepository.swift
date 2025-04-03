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
}
