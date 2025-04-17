
//
//  User.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

protocol DeleteUserTokenUseCase {
    func execute() -> Void
}

class DefaultDeleteUserUseCase: DeleteUserTokenUseCase {
    private let keychainRepository: IKeychainRepository
    
    init(keychainRepository: IKeychainRepository) {
        self.keychainRepository = keychainRepository
    }
    
    func execute() -> Void {
        keychainRepository.deleteLoginTokenData()
    }
}
