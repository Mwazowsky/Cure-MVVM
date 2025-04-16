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
    // MARK: - User Details
    func saveUserDetailsData(_ userData: UserDetailsDM) -> Bool {
        guard let encodedData = try? JSONEncoder().encode(userData) else {
            print("Failed to encode user data")
            return false
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: "currentUserDetailsData",
            kSecValueData as String: encodedData
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        return status == errSecSuccess
    }
    
    
    func getUserDetailsData() -> UserDetailsDM? {
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
        
        guard let keychainData = dataTypeRef as? Data else {
            print("Retrieved data is not of type Data")
            return nil
        }
        do {
            let userDetailsData: UserDetailsDM = try JSONDecoder().decode(UserDetailsDM.self, from: keychainData)
            return userDetailsData
        } catch {
            print("Decoding error: \(error)")
            return nil
        }
    }
    
    func deleteUserDetailsData() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: "currentUserDetailsData"
        ]
        
        let _ = SecItemDelete(query as CFDictionary)
    }
    
    // MARK: - User JWT Token
    func saveLoginTokenData(_ userData: LoginResponseDTO) -> Bool {
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
    
    func getLoginTokenData() -> LoginResponseDTO? {
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
    
    func deleteLoginTokenData() -> Void {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: "currentUserTokenData"
        ]
        
        let _ = SecItemDelete(query as CFDictionary)
    }
    
    // MARK: - FCM Token
    func saveFCMTokenData(_ fcmToken: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: "fcmTokenData",
            kSecValueData as String: fcmToken
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        return status == errSecSuccess
    }
    
    func getFCMTokenData() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: "fcmTokenData",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        guard status == errSecSuccess else { return nil }
        if status == errSecSuccess, let data = dataTypeRef as? String {
            return data
        }
        return nil
    }
    
    func deleteFCMTokenData() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: "fcmTokenData"
        ]
        
        let _ = SecItemDelete(query as CFDictionary)
    }
    
    // MARK: - Handled Contact
    func saveHandledContactData(_ value: [Int : [ChatContactDTO]]) -> Bool {
        do {
            let handledContactData = try JSONEncoder().encode(value)
            
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: keychainService,
                kSecAttrAccount as String: "handledContactData",
                kSecValueData as String: handledContactData
            ]
            
            SecItemDelete(query as CFDictionary)
            
            let status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                print("Error saving handled contact data: \(status)")
            }
            
            return status == errSecSuccess
            
        } catch {
            return false
        }
    }
    
    func getHandledContactData() -> [Int:[ChatContactDTO]]? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: "handledContactData",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        guard status == errSecSuccess else { return nil }
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            do {
                return try JSONDecoder().decode([Int:[ChatContactDTO]].self, from: data)
            } catch {
                print("Error decoding user data: \(error)")
                return nil
            }
        }
        return nil
    }
    
    func deleteHandledContactData() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: "handledContactData"
        ]
        
        let _ = SecItemDelete(query as CFDictionary)
    }
}


