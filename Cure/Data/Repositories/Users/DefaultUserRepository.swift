//
//  DefaultAuthRepository.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

final class DefaultUserRepository {
    private let dataTransferService: DataTransferService
    private let cache: UserDetailsResponseStorage
    private let backgroundQueue: DataTransferDispatchQueue
    
    init(
        dataTransferService: DataTransferService,
        cache: UserDetailsResponseStorage,
        backgroundQueue: DataTransferDispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.dataTransferService = dataTransferService
        self.cache = cache
        self.backgroundQueue = backgroundQueue
    }
}

extension DefaultUserRepository: IUserRepository {
    func fetchLoginUserDetails(
        cached: @escaping (UserDetailsDM) -> Void,
        completion: @escaping (Result<UserDetailsDM, Error>) -> Void
    ) {
        let task = RepositoryTask()
        
        cache.getResponse { [weak self, backgroundQueue] (result: Result<UserDetailsDTO?, DataTransferError>) in
            switch result {
            case .success(let response?):
                guard let cacheUserDTO = self?.mapToDomain(response: response) else {
                    DispatchQueue.main.async {
                        completion(.failure(AuthenticationError.unknownError))
                    }
                    return
                }
                cached(cacheUserDTO)
            case .success(nil):
                print("🟡 Cache is empty (success but nil)")
            case .failure(let error):
                print("❌ Failed to get from cache: \(error)")
            }
            
            guard !task.isCancelled else { return }
            
            let endpoint: Endpoint<UserDetailsResponse> = APIEndpoints.getLoginUserProfile()
            
            task.networkTask = self?.dataTransferService.request(
                with: endpoint,
                on: backgroundQueue
            ) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                    
                case .success(let response):
                    guard response.success, response.status == 200 else {
                        let error = NSError(domain: "YourApp.Network", code: response.status, userInfo: [
                            NSLocalizedDescriptionKey: response.message
                        ])
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                        return
                    }
                    
                    let netUserDTO = self.mapToDomain(response: response)
                    
                    self.cache.save(response: netUserDTO)
                    
                    let domainModel = self.mapToDomain(response: netUserDTO)
                    
                    DispatchQueue.main.async {
                        completion(.success(domainModel))
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
            email: response.email,
            phoneNumber: response.phoneNumber
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
