import Foundation

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    
    let windowManager: WindowManageable
    
    let socketService: SocketService
    let keychainService: DefaultKeychainRepository
    
    init(
        windowManager: WindowManageable
    ) {
        self.socketService = DefaultSocketService()
        self.keychainService = DefaultKeychainRepository()
        self.windowManager = windowManager
    }
    
    func makeWindowManager() -> WindowManageable {
        return windowManager
    }
    
    // MARK: - Network
    /// This is data service based on the base url, if there are many different base urls, add more of this
    /// in here I have 3 base urls for old, new(cure related), and image
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(
            baseURL: URL(string: appConfiguration.apiBaseURL)!,
            queryParameters: [
                "api_key": appConfiguration.apiKey,
                "language": NSLocale.preferredLanguages.first ?? "en"
            ]
        )
        
        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    
    lazy var newApiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(
            baseURL: URL(string: appConfiguration.newApiBaseURL)!
        )
        
        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    
    lazy var imageDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(
            baseURL: URL(string: appConfiguration.imagesBaseURL)!
        )
        let imagesDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: imagesDataNetwork)
    }()
    
    // MARK: - DIContainers of scenes
    /// This will initialize all scenes DI Container. Add new entries as your app grows
    func makeAuthSceneDIContainer() -> AuthSceneDIContainer {
        let dependencies = AuthSceneDIContainer.Dependencies(
            newApiDataTransferervice: newApiDataTransferService
        )
        return AuthSceneDIContainer(dependencies: dependencies)
    }
    
    
    func makeHomeSceneDIContainer() -> HomeSceneDIContainer {
        let dependencies = HomeSceneDIContainer.Dependencies(
            newApiDataTransferervice: newApiDataTransferService
        )
        return HomeSceneDIContainer(dependencies: dependencies, windowManager: windowManager)
    }
    
    
    func makeAccountSceneDIContainer() -> AccountSceneDIContainer {
        let dependencies = AccountSceneDIContainer.Dependencies(
            newApiDataTransferervice: newApiDataTransferService
        )
        return AccountSceneDIContainer(dependencies: dependencies)
    }
    
    
    func makeMoviesSceneDIContainer() -> MoviesSceneDIContainer {
        let dependencies = MoviesSceneDIContainer.Dependencies(
            apiDataTransferService: apiDataTransferService,
            newApiDataTransferervice: newApiDataTransferService,
            imageDataTransferService: imageDataTransferService
        )
        return MoviesSceneDIContainer(dependencies: dependencies)
    }
    
    func makeChatContactsSceneDIContainer() -> ChatContactsDIContainer {
        let dependencies = ChatContactsDIContainer.Dependencies(
            apiDataTransferService: apiDataTransferService,
            newApiDataTransferervice: newApiDataTransferService,
            imageDataTransferService: imageDataTransferService
        )
        
        return ChatContactsDIContainer(dependencies: dependencies)
    }
}
