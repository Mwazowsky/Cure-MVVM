//
//  User.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

protocol SaveLoginTokenUseCase {
    func execute(token: LoginResponseDTO) -> Bool
}

class DefaultSaveLoginTokenUseCase: SaveLoginTokenUseCase {
    private let keychainRepository: IKeychainRepository
    
    init(keychainRepository: IKeychainRepository) {
        self.keychainRepository = keychainRepository
    }
    
    func execute(token: LoginResponseDTO) -> Bool {
        return keychainRepository.saveLoginTokenData(token)
    }
}
