//
//  User.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

protocol SaveUserUseCase {
    func execute(userData: LoginResponseDTO) -> Bool
}

class DefaultSaveUserUseCase: SaveUserUseCase {
    private let keychainRepository: KeychainRepository
    
    init(keychainRepository: KeychainRepository) {
        self.keychainRepository = keychainRepository
    }
    
    func execute(userData: LoginResponseDTO) -> Bool {
        return keychainRepository.saveUserData(userData)
    }
}
