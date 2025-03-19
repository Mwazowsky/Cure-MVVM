//
//  UsersRepository.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

protocol UsersRepository {
    func getCurrentUser(completion: @escaping (Result<User?, Error>) -> Void)
}
