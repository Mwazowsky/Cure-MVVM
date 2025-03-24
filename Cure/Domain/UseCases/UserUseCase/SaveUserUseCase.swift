//
//  User.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

protocol SaveUserUseCase {
    func execute(userData: User) -> Bool
}

class DefaultSaveUserUseCase: SaveUserUseCase {
    private let userRepository: UsersRepository
    
    init(userRepository: UsersRepository) {
        self.userRepository = userRepository
    }
    
    func execute(userData: User) -> Bool {
        return userRepository.saveUserData(userData)
    }
}
