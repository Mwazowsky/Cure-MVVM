//
//  User.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

protocol GetUserUseCase {
    func execute() -> LoginResponseDTO?
}

final class DefaultGetCurrentUserUseCase: GetUserUseCase {
    private let keychainRepository: KeychainRepository
    
    init(keychainRepository: KeychainRepository) {
        self.keychainRepository = keychainRepository
    }
    
    func execute() -> LoginResponseDTO? {
        return keychainRepository.getUserData()
    }
}
