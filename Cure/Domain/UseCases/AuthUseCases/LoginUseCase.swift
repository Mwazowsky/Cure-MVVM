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
    private let authRepository: IAuthRepository
    
    private let deviceInfoRepository: IDeviceInfoRepository
    
    init(
        authRepository: IAuthRepository,
        deviceInfoRepository: IDeviceInfoRepository
    ) {
        self.authRepository = authRepository
        self.deviceInfoRepository = deviceInfoRepository
    }
    
    func execute(requestValue: LoginUseCaseRequestValue, completion: @escaping (Result<LoginResponse, AuthenticationError>) -> Void) {
        guard !requestValue.email.isEmpty, !requestValue.password.isEmpty else {
            completion(.failure(.invalidCredentials))
            return
        }
        
        var serial = deviceInfoRepository.serial
        
        #if DEBUG
        serial = "p1s4ngc0kl4t"
        #endif
        
        let metadata = LoginMetadataDTO(
            platform: deviceInfoRepository.platform,
            version: deviceInfoRepository.version,
            manufacturer: deviceInfoRepository.manufacturer,
            model: deviceInfoRepository.model,
            serial: serial,
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
