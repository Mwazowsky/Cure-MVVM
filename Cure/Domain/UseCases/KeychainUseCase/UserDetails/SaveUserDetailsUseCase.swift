//
//  SaveUserDetailsUseCase.swift
//  Cure
//
//  Created by MacBook Air MII  on 3/4/25.
//

import Foundation

protocol SaveUserDetailsUseCase {
    func execute(userData: UserDetailsDTO) -> Bool
}

final class DefaultSaveCurrentUserDetailsUseCase: SaveUserDetailsUseCase {
    private let keychainRepository: IKeychainRepository
    
    init(keychainRepository: IKeychainRepository) {
        self.keychainRepository = keychainRepository
    }
    
    func execute(userData: UserDetailsDTO) -> Bool {
        return keychainRepository.saveUserDetailsData(userData)
    }
}
