//
//  LoginUseCase.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 18/03/25.
//

protocol LoginUseCase {
    func execute(requestValue: LoginUseCaseRequestValue, completion: @escaping (Result<User, AuthenticationError>) -> Void)
}

struct LoginUseCaseRequestValue {
    let email: String
    let password: String
}

final class DefaultLoginUseCase: LoginUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(requestValue: LoginUseCaseRequestValue, completion: @escaping (Result<User, AuthenticationError>) -> Void) {
        guard !requestValue.email.isEmpty, !requestValue.password.isEmpty else {
            completion(.failure(.invalidCredentials))
            return
        }
        
        return authRepository.login(
            email: requestValue.email,
            password: requestValue.password,
            completion: completion
        )
    }
}
