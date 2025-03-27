import Foundation

final class AppConfiguration {
    lazy var apiKey: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "ApiKey") as? String else {
            fatalError("ApiKey must not be empty in plist")
        }
        return apiKey
    }()
    lazy var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
    lazy var newApiBaseURL: String = {
        guard let newApiBaseURL = Bundle.main.object(forInfoDictionaryKey: "NewApiBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return newApiBaseURL
    }()
    lazy var keyConnection: String = {
        guard let keyConnection = Bundle.main.object(forInfoDictionaryKey: "KEY_CONNECTION") as? String else {
            fatalError("keyConnection must not be empty in plist")
        }
        return keyConnection
    }()
    lazy var imagesBaseURL: String = {
        guard let imageBaseURL = Bundle.main.object(forInfoDictionaryKey: "ImageBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return imageBaseURL
    }()
}
