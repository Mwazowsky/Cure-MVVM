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
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(completion: @escaping (Result<Bool, Error>) -> Void) {
        return authRepository.logout(completion: completion)
    }
}
