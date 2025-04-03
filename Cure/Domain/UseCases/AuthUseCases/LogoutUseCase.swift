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
    private let keychainRepository: KeychainRepository
    
    init(authRepository: AuthRepository,
         keychainRepository: KeychainRepository) {
        self.keychainRepository = keychainRepository
        self.authRepository = authRepository
    }
    
    func execute(completion: @escaping (Result<Bool, Error>) -> Void) {
        authRepository.logout { result in
            switch result {
            case .success(let isSuccess):
                if isSuccess {
                    self.keychainRepository.deleteUserData()
                }
                completion(.success(isSuccess))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
