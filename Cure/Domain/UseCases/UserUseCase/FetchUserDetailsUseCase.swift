//
//  LoginUseCase.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 18/03/25.
//

protocol FetchUserDetailsUseCase {
    func execute(completion: @escaping (Result<UserDetailsDTO, Error>) -> Void)
}

final class DefaultFetchUserDetailsUseCase: FetchUserDetailsUseCase {
    private let userRepository: IUserRepository
    
    init(
        userRepository: IUserRepository
    ) {
        self.userRepository = userRepository
    }
    
    func execute(completion: @escaping (Result<UserDetailsDTO, Error>) -> Void) {
        return userRepository.fetchLoginUserDetails(completion: completion)
    }
}
