
//
//  User.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

protocol DeleteUserUseCase {
    func execute() -> Bool
}

class DefaultDeleteUserUseCase: DeleteUserUseCase {
    private let keychainRepository: KeychainRepository
    
    init(keychainRepository: KeychainRepository) {
        self.keychainRepository = keychainRepository
    }
    
    func execute() -> Bool {
        return keychainRepository.deleteUserData()
    }
}
