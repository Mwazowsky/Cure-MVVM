//
//  LogoutUseCase.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

protocol LogoutUseCase {
    func execute(completion: @escaping (Result<Bool, Error>) -> Void)
}

final class DefaultLogoutUseCase: LogoutUseCase {
    private let authRepository: AuthRepository
    private let KeychainRepository: KeychainRepository
    
    init(authRepository: AuthRepository,
         keychainRepository: KeychainRepository) {
        self.KeychainRepository = keychainRepository
        
    }
    
    func execute(completion: @escaping (Result<Bool, Error>) -> Void) {
        let isKeychainDataDeleted = KeychainRepository.deleteUserData()
        return authRepository.logout(completion: completion)
    }
}
