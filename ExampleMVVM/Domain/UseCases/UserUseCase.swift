//
//  User.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

protocol GetCurrentUserUseCase {
    func execute(completion: @escaping (Result<User?, Error>) -> Void)
}

final class DefaultGetCurrentUserUseCase: GetCurrentUserUseCase {
    private let userRepository: UsersRepository
    
    init(userRepository: UsersRepository) {
        self.userRepository = userRepository
    }
    
    func execute(completion: @escaping (Result<User?, any Error>) -> Void) {
        return userRepository.getCurrentUser(completion: completion)
    }
}
