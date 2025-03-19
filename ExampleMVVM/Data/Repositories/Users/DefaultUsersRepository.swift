//
//  DefaultUsersRepository.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

final class DefaultUsersRepository {
    private let dataTransferService: DataTransferService
    private let cache: MoviesResponseStorage // Change this to keychain service storage, since data related to user need to be secured
    private let backgroundQueue: DataTransferDispatchQueue
    
    init(
        dataTransferService: DataTransferService,
        cache: MoviesResponseStorage,
        backgroundQueue: DataTransferDispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.dataTransferService = dataTransferService
        self.cache = cache
        self.backgroundQueue = backgroundQueue
    }
}

extension DefaultUsersRepository: UsersRepository {
    func getCurrentUser(completion: @escaping (Result<User?, any Error>) -> Void) {
        print("Implementation of UsersRepository.getCurrentUser")
    }
}


