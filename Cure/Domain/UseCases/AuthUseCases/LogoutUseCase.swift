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
    private let authRepository: IAuthRepository
    private let keychainRepository: IKeychainRepository
    
    init(authRepository: IAuthRepository,
         keychainRepository: IKeychainRepository) {
        self.keychainRepository = keychainRepository
        self.authRepository = authRepository
    }
    
    func execute(completion: @escaping (Result<Bool, Error>) -> Void) {
        authRepository.logout { result in
            switch result {
            case .success(let isSuccess):
                if isSuccess {
                    self.keychainRepository.deleteUserTokenData()
                }
                completion(.success(isSuccess))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
