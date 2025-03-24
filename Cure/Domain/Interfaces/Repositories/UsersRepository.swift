//
//  UsersRepository.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

protocol UsersRepository {
    func saveUserData(_ userData: User) -> Bool
    func getUserData() -> User?
    func deleteUserData() -> Bool
}
