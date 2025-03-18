//
//  AuthRepository.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 18/03/25.
//

protocol AuthRepository {
    func login(email: String, password: String, completion: @escaping (Result<User, AuthenticationError>) -> Void)
    func register(username: String, email: String, password: String, completion: @escaping (Result<User, AuthenticationError>) -> Void)
    func resetPassword(email: String, completion: @escaping (Result<Bool, AuthenticationError>) -> Void)
    func logout(completion: @escaping (Result<Bool, Error>) -> Void)
    func getCurrentUser(completion: @escaping (Result<User?, Error>) -> Void)
}
