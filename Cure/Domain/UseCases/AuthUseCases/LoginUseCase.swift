//
//  LoginUseCase.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 18/03/25.
//

protocol LoginUseCase {
    func execute(requestValue: LoginUseCaseRequestValue, completion: @escaping (Result<LoginResponse, AuthenticationError>) -> Void)
}

struct LoginUseCaseRequestValue {
    let email: String
    let password: String
}

final class DefaultLoginUseCase: LoginUseCase {
    private let authRepository: AuthRepository
    
    private let deviceInfoRepository: DeviceInfoRepository
    
    init(
        authRepository: AuthRepository,
        deviceInfoRepository: DeviceInfoRepository
    ) {
        self.authRepository = authRepository
        self.deviceInfoRepository = deviceInfoRepository
    }
    
    func execute(requestValue: LoginUseCaseRequestValue, completion: @escaping (Result<LoginResponse, AuthenticationError>) -> Void) {
        guard !requestValue.email.isEmpty, !requestValue.password.isEmpty else {
            completion(.failure(.invalidCredentials))
            return
        }
        
        let metadata = LoginMetadataDTO(
            platform: deviceInfoRepository.platform,
            version: deviceInfoRepository.version,
            manufacturer: deviceInfoRepository.manufacturer,
            model: deviceInfoRepository.model,
            serial: deviceInfoRepository.serial,
            fcmToken: "nasdjkansdmadnsaidh99djkkwk"
        )
        
        let requestData: LoginRequestDTO = LoginRequestDTO(
            email: requestValue.email,
            password: requestValue.password,
            metadata: metadata
        )
        
        return authRepository.login(
            request: requestData,
            completion: completion
        )
    }
}
