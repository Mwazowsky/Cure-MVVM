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
    private let keychainRepository: IKeychainRepository
    
    init(keychainRepository: IKeychainRepository) {
        self.keychainRepository = keychainRepository
    }
    
    func execute(userData: LoginResponseDTO) -> Bool {
        return keychainRepository.saveUserTokenData(userData)
    }
}
