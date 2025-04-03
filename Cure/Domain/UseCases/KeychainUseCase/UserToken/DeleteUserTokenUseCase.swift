
//
//  User.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

protocol DeleteUserUseCase {
    func execute() -> Void
}

class DefaultDeleteUserUseCase: DeleteUserUseCase {
    private let keychainRepository: IKeychainRepository
    
    init(keychainRepository: IKeychainRepository) {
        self.keychainRepository = keychainRepository
    }
    
    func execute() -> Void {
        keychainRepository.deleteUserTokenData()
    }
}
