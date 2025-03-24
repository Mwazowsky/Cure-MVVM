//
//  DefaultAuthRepository.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

final class DefaultAuthRepository {
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

extension DefaultAuthRepository: AuthRepository {
    func login(
        request: LoginRequestDTO,
        completion: @escaping (Result<LoginResponse, AuthenticationError>) -> Void
    ) {
        let requestDTO = LoginRequestDTO(username: request.username, password: request.password)
        let task = RepositoryTask()
        
        let endpoint = APIEndpoints.login(with: requestDTO)
        
        dataTransferService.request(with: endpoint) { [weak self] (result: Result<LoginResponseDTO, DataTransferError>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                let user = self.mapToDomain(response: response)
//                self.persistenceService.saveToken(token: response.token)
                completion(.success(user))
            case .failure(let error):
                completion(.failure(self.mapError(error)))
            }
        }
    }
    
    func register(
        request: RegisterRequestDTO,
        completion: @escaping (Result<RegisterResponse, AuthenticationError>) -> Void
    ) {
        let requestDTO = RegisterRequestDTO(namaLengkap: request.namaLengkap, username: request.username, password: request.password)
        let task = RepositoryTask()
        
        let endpoint = APIEndpoints.register(with: requestDTO)
        
        dataTransferService.request(with: endpoint) { [weak self] (result: Result<RegisterResponseDTO, DataTransferError>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                let user = self.mapToDomain(response: response)
//                self.persistenceService.saveToken(token: response.token)
                completion(.success(user))
            case .failure(let error):
                completion(.failure(self.mapError(error)))
            }
        }
    }
    
    func resetPassword(username: String, completion: @escaping (Result<Bool, AuthenticationError>) -> Void) {
        print("Implementation of DefaultAuthRepository.resetPassword")
    }
    
    func logout(completion: @escaping (Result<Bool, any Error>) -> Void) {
        print("Implementation of DefaultAuthRepository.logout")
    }
}


// MARK: Domain mapper
extension DefaultAuthRepository {
    private func mapToDomain(response: LoginResponseDTO) -> LoginResponse {
        return LoginResponse(
            id: response.id,
            username: response.username,
            role: UserResponseDTO.RoleDTO(rawValue: response.role.rawValue) ?? .staff,
            token: response.token
        )
    }
    
    
    private func mapToDomain(response: RegisterResponseDTO) -> RegisterResponse {
        return RegisterResponse(
            id: response.id,
            username: response.username,
            namaLengkap: response.namaLengkap,
            password: response.password,
            role: UserResponseDTO.RoleDTO(rawValue: response.role.rawValue) ?? .staff
        )
    }
    
    
    private func mapToDomain(response: UserResponseDTO) -> User {
        return User(
            id: response.id,
            username: response.username,
            namaLengkap: response.namaLengkap,
            role: response.role
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
