//
//  User.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

protocol GetUserUseCase {
    func execute() -> User?
}

final class DefaultGetCurrentUserUseCase: GetUserUseCase {
    private let userRepository: UsersRepository
    
    init(userRepository: UsersRepository) {
        self.userRepository = userRepository
    }
    
    func execute() -> User? {
        return userRepository.getUserData()
    }
}
