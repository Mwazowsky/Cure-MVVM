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

extension DefaultAuthRepository: IAuthRepository {
    func login(
        request: LoginRequestDTO,
        completion: @escaping (Result<LoginResponse, AuthenticationError>) -> Void
    ) {
        let requestDTO = LoginRequestDTO(
            email: request.email,
            password: request.password,
            metadata: request.metadata
        )
        let endpoint = APIEndpoints.login(with: requestDTO)
        dataTransferService.request(with: endpoint) { [weak self] (result: Result<LoginResponse, DataTransferError>) in
            guard let self = self else { return }
            print("Login Result: ", result)
            
            switch result {
            case .success(let response):
                if response.success == false || response.status >= 400 {
                    let errorMessage = response.message
                    let errorDetail = response.error?.detail ?? ""
                    let authError = AuthenticationError.serverError(errorMessage + ": " + errorDetail)
                    completion(.failure(authError))
                } else {
                    completion(.success(response))
                }
            case .failure(let error):
                completion(.failure(self.mapError(error)))
            }
        }
    }
    
    func register(
        request: RegisterRequestDTO,
        completion: @escaping (Result<RegisterResponseDTO, AuthenticationError>) -> Void
    ) {
        let requestDTO = RegisterRequestDTO(namaLengkap: request.namaLengkap, email: request.email, password: request.password)
        
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
        let endpoint = APIEndpoints.logout()
        
        dataTransferService.request(with: endpoint) { [weak self] (result:  Result<LoginResponse, DataTransferError>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                completion(.success(response.status == 200))
            case .failure(let error):
                completion(.failure(self.mapError(error)))
            }
        }
    }
}


// MARK: Domain mapper
extension DefaultAuthRepository {
    private func mapToDomain(response: LoginResponse) -> LoginResponseDTO {
        return LoginResponseDTO(
            token: response.data?.token ?? ""
        )
    }
    
    
    private func mapToDomain(response: RegisterResponseDTO) -> RegisterResponseDTO {
        return RegisterResponseDTO(
            id: response.id,
            username: response.username,
            namaLengkap: response.namaLengkap,
            password: response.password,
            role: RegisterResponseDTO.RoleDTO(rawValue: response.role.rawValue) ?? .staff
        )
    }
    
    /// CORRECT DTO > DM: This is how you convert the response from DTO to DM
    private func mapToDomain(response: LoginResponseDTO) -> LoginDM {
        return LoginDM(
            token: response.token
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
