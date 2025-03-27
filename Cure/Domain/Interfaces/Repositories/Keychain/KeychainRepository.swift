//
//  UsersRepository.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

protocol KeychainRepository {
    func saveUserData(_ userData: LoginResponseDTO) -> Bool
    func getUserData() -> LoginResponseDTO?
    func deleteUserData() -> Bool
}
