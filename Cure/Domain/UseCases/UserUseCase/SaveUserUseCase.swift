//
//  User.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

protocol SaveUserUseCase {
    func execute(userData: LoginResponseDTO) -> Bool
}

class DefaultSaveUserUseCase: SaveUserUseCase {
    private let userRepository: UsersRepository
    
    init(userRepository: UsersRepository) {
        self.userRepository = userRepository
    }
    
    func execute(userData: LoginResponseDTO) -> Bool {
        return userRepository.saveUserData(userData)
    }
}
