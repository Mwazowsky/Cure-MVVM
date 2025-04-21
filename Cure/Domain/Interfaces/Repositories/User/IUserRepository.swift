//
//  IUserRepository.swift
//  Cure
//
//  Created by MacBook Air MII  on 3/4/25.
//

protocol IUserRepository {
    func fetchLoginUserDetails(
        cached: @escaping (UserDetailsDM) -> Void,
        completion: @escaping (Result<UserDetailsDM, Error>) -> Void
    )
}
