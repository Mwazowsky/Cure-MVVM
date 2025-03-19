//
//  ResetPasswordUseCase.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 18/03/25.
//

import Foundation

protocol ResetPasswordUseCase {
    func execute(requestValue: ResetPasswordUseCaseRequestValue, completion: @escaping (Result<Bool, AuthenticationError>) -> Void)
}

struct ResetPasswordUseCaseRequestValue {
    let email: String
}

final class DefaultResetPasswordUseCase: ResetPasswordUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(
        requestValue: ResetPasswordUseCaseRequestValue,
        completion: @escaping (Result<Bool, AuthenticationError>) -> Void
    ) {
        guard !requestValue.email.isEmpty else {
            completion(.failure(.invalidCredentials))
            
            return
        }
        
        return authRepository.resetPassword(
            email: requestValue.email,
            completion: completion
        )
    }
}
