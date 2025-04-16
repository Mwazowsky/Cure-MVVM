//
//  User.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

protocol GetUserTokenUseCase {
    func execute() -> LoginResponseDTO?
}

final class DefaultGetCurrentUserTokenUseCase: GetUserTokenUseCase {
    private let keychainRepository: IKeychainRepository
    
    init(keychainRepository: IKeychainRepository) {
        self.keychainRepository = keychainRepository
    }
    
    func execute() -> LoginResponseDTO? {
        return keychainRepository.getLoginTokenData()
    }
}
