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

extension DefaultKeychainRepository: IKeychainRepository {
    func saveUserDetailsData(_ userData: UserDetailsDTO) -> Bool {
        do {
            let userDetailsData = try JSONEncoder().encode(userData)
            
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: keychainService,
                kSecAttrAccount as String: "currentUserDetailsData",
                kSecValueData as String: userData
            ]
            
            SecItemDelete(query as CFDictionary)
            
            let status = SecItemAdd(query as CFDictionary, nil)
            
            return status == errSecSuccess
        } catch {
            return false
        }
    }
    
    func getUserDetailsData() -> UserDetailsDTO? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: "currentUserDetailsData",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        guard status == errSecSuccess else { return nil }
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            do {
                return try JSONDecoder().decode(UserDetailsDTO.self, from: data)
            } catch {
                print("Error decoding user data: \(error)")
                return nil
            }
        }
        return nil
    }
    
    func deleteUserDetailsData() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: "currentUserDetailsData"
        ]
        
        let _ = SecItemDelete(query as CFDictionary)
    }
    
    
    func saveUserTokenData(_ userData: LoginResponseDTO) -> Bool {
        do {
            let userData = try JSONEncoder().encode(userData)
            
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: keychainService,
                kSecAttrAccount as String: "currentUserTokenData",
                kSecValueData as String: userData
            ]
            
            SecItemDelete(query as CFDictionary)
            
            let status = SecItemAdd(query as CFDictionary, nil)
            
            return status == errSecSuccess
        } catch {
            return false
        }
    }
    
    func getUserTokenData() -> LoginResponseDTO? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: "currentUserTokenData",
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
    
    func deleteUserTokenData() -> Void {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: "currentUserTokenData"
        ]
        
        let _ = SecItemDelete(query as CFDictionary)
    }
}


