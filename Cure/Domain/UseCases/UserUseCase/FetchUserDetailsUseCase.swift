//
//  LoginUseCase.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 18/03/25.
//

protocol FetchUserDetailsUseCase {
    func execute(cached: @escaping (UserDetailsDM) -> Void, completion: @escaping (Result<UserDetailsDM, Error>) -> Void)
}

final class DefaultFetchUserDetailsUseCase: FetchUserDetailsUseCase {
    private let userRepository: IUserRepository
    
    init(
        userRepository: IUserRepository
    ) {
        self.userRepository = userRepository
    }
    
    func execute(cached: @escaping (UserDetailsDM) -> Void, completion: @escaping (Result<UserDetailsDM, Error>) -> Void) {
        return userRepository.fetchLoginUserDetails(cached: cached, completion: completion)
    }
}
