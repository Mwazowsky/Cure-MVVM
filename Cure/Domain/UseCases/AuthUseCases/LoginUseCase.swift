//
//  LoginUseCase.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 18/03/25.
//

protocol LoginUseCase {
    func execute(requestValue: LoginUseCaseRequestValue, completion: @escaping (Result<LoginResponseDTO, AuthenticationError>) -> Void)
}

struct LoginUseCaseRequestValue {
    let username: String
    let password: String
}

final class DefaultLoginUseCase: LoginUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(requestValue: LoginUseCaseRequestValue, completion: @escaping (Result<LoginResponseDTO, AuthenticationError>) -> Void) {
        guard !requestValue.username.isEmpty, !requestValue.password.isEmpty else {
            completion(.failure(.invalidCredentials))
            return
        }
        
        let requestData: LoginRequestDTO = LoginRequestDTO(
            username: requestValue.username, password: requestValue.password
        )
        
        print("request data [loginUseCase.execute()]: ", requestData)
        
        return authRepository.login(
            request: requestData,
            completion: completion
        )
    }
}
