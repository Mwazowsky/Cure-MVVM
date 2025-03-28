//
//  DefaultUsersRepository.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

final class DefaultKeychainRepository {
    private let keychainService = "com.softwaremediainnovation.CURE.userData"
}

extension DefaultKeychainRepository: KeychainRepository {
    
    func saveUserData(_ userData: LoginResponseDTO) -> Bool {
        do {
            let userData = try JSONEncoder().encode(userData)
            
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: keychainService,
                kSecAttrAccount as String: "currentUserData",
                kSecValueData as String: userData
            ]
            
            print("Keychain save query: ", query)
            
            SecItemDelete(query as CFDictionary)
            
            let status = SecItemAdd(query as CFDictionary, nil)
            
            print("Keychain save status: ", status)
            return status == errSecSuccess
        } catch {
            return false
        }
    }
    
    func getUserData() -> LoginResponseDTO? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: "currentUserData",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        guard status == errSecSuccess else { return nil }
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            do {
                return try JSONDecoder().decode(LoginResponseDTO.self, from: data)
            } catch {
                print("Error decoding user data: \(error)")
                return nil
            }
        }
        return nil
    }
    
    func deleteUserData() -> Void {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: "currentUserData"
        ]
        
        let _ = SecItemDelete(query as CFDictionary)
    }
}


