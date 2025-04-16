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
        completion: @escaping (Result<UserDetailsDM, Error>) -> Void
    ) {
        let endpoint = APIEndpoints.getLoginUserProfile()
        backgroundQueue.asyncExecute {
            self.dataTransferService.request(with: endpoint) { [weak self] (result: Result<UserDetailsResponse, DataTransferError>) in
                guard self != nil else { return }
                switch result {
                case .success(let response):
                    guard let userDTO = self?.mapToDomain(response: response) else {
                        DispatchQueue.main.async {
                            completion(.failure(AuthenticationError.unknownError))
                        }
                        return
                    }
                    
                    if let userDomainModel = self?.mapToDomain(response: userDTO) {
                        DispatchQueue.main.async {
                            completion(.success(userDomainModel))
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(.failure(AuthenticationError.unknownError))
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}

extension DefaultUserRepository {
    private func mapToDomain(response: UserDetailsResponse) -> UserDetailsDTO {
        guard let responseData = response.data else {
            fatalError("Received invalid user details response")
        }
        
        return responseData
    }
    
    private func mapToDomain(response: UserDetailsDTO) -> UserDetailsDM {
        return UserDetailsDM(
            employeeID: response.employeeID,
            companyID: response.companyID,
            dob: response.dob,
            gender: response.gender,
            address: response.address,
            companyName: response.companyName,
            name: response.name,
            email: response.email
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
