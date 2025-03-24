//
//  RegisterUseCase.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 18/03/25.
//

import Foundation

protocol RegisterUseCase {
    func execute(requestValue: RegisterUseCaseRequestValue, completion: @escaping (Result<RegisterResponse, AuthenticationError>) -> Void)
}


struct RegisterUseCaseRequestValue {
    let username: String
    let namaLengkap: String
    let password: String
    let confirmPassword: String
}


final class DefaultRegisterUseCase: RegisterUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(requestValue: RegisterUseCaseRequestValue, completion: @escaping (Result<RegisterResponse, AuthenticationError>) -> Void) {
        guard !requestValue.username.isEmpty,
              !requestValue.username.isEmpty,
              !requestValue.password.isEmpty,
              !requestValue.confirmPassword.isEmpty else {
            completion(.failure(.invalidCredentials))
            return
        }
        
        
        guard requestValue.password == requestValue.confirmPassword else {
            completion(.failure(.invalidCredentials))
            return
        }
        
        guard requestValue.password.count >= 8 else {
            completion(.failure(.weakPassword))
            return
        }
        
        let requestData: RegisterRequestDTO = RegisterRequestDTO(
            namaLengkap: requestValue.namaLengkap,
            username: requestValue.username,
            password: requestValue.password
        )
        
        return authRepository.register(
            request: requestData,
            completion: completion
        )
    }
}
