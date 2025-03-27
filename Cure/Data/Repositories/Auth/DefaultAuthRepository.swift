//
//  DefaultAuthRepository.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

final class DefaultAuthRepository {
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

extension DefaultAuthRepository: AuthRepository {
    func login(
        request: LoginRequestDTO,
        completion: @escaping (Result<LoginResponse, AuthenticationError>) -> Void
    ) {
        let requestDTO = LoginRequestDTO(username: request.username, password: request.password)
        let endpoint = APIEndpoints.login(with: requestDTO)
        print("Login Endpoint: ", endpoint)
        dataTransferService.request(with: endpoint) { [weak self] (result:  Result<LoginResponse, DataTransferError>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(self.mapError(error)))
            }
        }
    }
    
    func register(
        request: RegisterRequestDTO,
        completion: @escaping (Result<RegisterResponseDTO, AuthenticationError>) -> Void
    ) {
        let requestDTO = RegisterRequestDTO(namaLengkap: request.namaLengkap, username: request.username, password: request.password)
        
        let endpoint = APIEndpoints.register(with: requestDTO)
        
        dataTransferService.request(with: endpoint) { [weak self] (result: Result<RegisterResponseDTO, DataTransferError>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(self.mapError(error)))
            }
        }
    }
    
    func resetPassword(email: String, completion: @escaping (Result<Bool, AuthenticationError>) -> Void) {
        print("Implementation of DefaultAuthRepository.resetPassword")
    }
    
    func logout(completion: @escaping (Result<Bool, any Error>) -> Void) {
        print("Implementation of DefaultAuthRepository.logout")
    }
}


// MARK: Domain mapper
extension DefaultAuthRepository {
    private func mapToDomain(response: LoginResponse) -> LoginResponseDTO {
        return LoginResponseDTO(
            userId: response.data.userId,
            email: response.data.email,
            expiredAt: response.data.expiredAt,
            role: UserResponseDTO.RoleDTO(rawValue: response.data.role.rawValue) ?? .staff,
            token: response.data.token
        )
    }
    
    
    private func mapToDomain(response: RegisterResponseDTO) -> RegisterResponseDTO {
        return RegisterResponseDTO(
            id: response.id,
            username: response.username,
            namaLengkap: response.namaLengkap,
            password: response.password,
            role: UserResponseDTO.RoleDTO(rawValue: response.role.rawValue) ?? .staff
        )
    }
    
    
    private func mapToDomain(response: LoginResponseDTO) -> User {
        return User(
            user_id: response.userId,
            email: response.email,
            expiredAt: response.expiredAt,
            role: response.role,
            accessToken: response.token
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
