//
//  AuthRepository.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 18/03/25.
//

protocol AuthRepository {
    func login(request: LoginRequestDTO, completion: @escaping (Result<LoginResponse, AuthenticationError>) -> Void)
    func register(request: RegisterRequestDTO, completion: @escaping (Result<RegisterResponse, AuthenticationError>) -> Void)
    func resetPassword(email: String, completion: @escaping (Result<Bool, AuthenticationError>) -> Void)
    func logout(completion: @escaping (Result<Bool, Error>) -> Void)
}
