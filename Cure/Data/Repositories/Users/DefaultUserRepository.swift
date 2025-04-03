//
//  DefaultAuthRepository.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

final class DefaultUserRepository {
    private let dataTransferService: DataTransferService
    private let backgroundQueue: DataTransferDispatchQueue
    
    init(
        dataTransferService: DataTransferService,
        backgroundQueue: DataTransferDispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.dataTransferService = dataTransferService
        self.backgroundQueue = backgroundQueue
    }
}

extension DefaultUserRepository: IUserRepository {
    func fetchLoginUserDetails(
        completion: @escaping (Result<UserDetailsDTO, Error>) -> Void
    ) {
        let endpoint = APIEndpoints.getLoginUserProfile()
        
        dataTransferService.request(with: endpoint) { [weak self] (result: Result<UserDetailsDTO, DataTransferError>) in
            guard let self = self else { return }
            print("Fetch User Result: ", result)
            
            switch result {
            case .success(let response):
                    completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension DefaultUserRepository {
    private func mapToDomain(response: UserDetailsResponse) -> UserDetailsDTO {
        return UserDetailsDTO(
            
        )
    }
    
    private func mapError(_ error: DataTransferError) -> AuthenticationError {
        switch error {
        case .networkFailure:
            return .networkFailure
        case .resolvedNetworkFailure(let error):
            guard let apiError = error as? AuthenticationError else { return .unknownError }
            
            switch apiError {
            case .invalidCredentials:
                return .invalidCredentials
            case .weakPassword:
                return .weakPassword
            case .serverError(let message):
                return .serverError(message)
            default:
                return .unknownError
            }
        default:
            return .unknownError
        }
    }
}
