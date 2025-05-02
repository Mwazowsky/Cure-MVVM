import Foundation


/// Note: This could potentially be a humongous file, if there is a bunch of endpoints
struct APIEndpoints {
    // MARK: - Template Endpoints
    /// 3rd Wheel in case Im lost
    static func getMovies(with moviesRequestDTO: MoviesRequestDTO) -> Endpoint<MoviesResponseDTO> {
        return Endpoint(
            path: "3/search/movie",
            method: .get,
            queryParametersEncodable: moviesRequestDTO
        )
    }

    static func getMoviePoster(path: String, width: Int) -> Endpoint<Data> {
        let sizes = [92, 154, 185, 342, 500, 780]
        let closestWidth = sizes
            .enumerated()
            .min { abs($0.1 - width) < abs($1.1 - width) }?
            .element ?? sizes.first!
        
        return Endpoint(
            path: "t/p/w\(closestWidth)\(path)",
            method: .get,
            responseDecoder: RawDataResponseDecoder()
        )
    }
    
    // MARK: - Auth Endpoints
    /// Login
    static func login(with loginRequestDTO: LoginRequestDTO) -> Endpoint<LoginResponse> {
        
        let headerParameters = [
            "accept": "*/*",
            "Content-Type": "application/json",
            "x-api-key": apiKey
        ]
        
        return Endpoint(
            path: "api/auth/login",
            method: .post,
            headerParameters: headerParameters,
            bodyParametersEncodable: loginRequestDTO
        )
    }
    
    /// Get User Profile
    static func getLoginUserProfile() -> Endpoint<UserDetailsResponse> {
        
        let headerParameters = [
            "accept": "*/*",
            "Content-Type": "application/json",
            "Authorization": "Bearer \(TokenManager.shared.getToken())",
            "x-api-key": apiKey
        ]
        
        return Endpoint(
            path: "api/auth",
            method: .get,
            headerParameters: headerParameters
        )
    }
    
    /// Logout
    static func logout() -> Endpoint<LoginResponse> {
        
        let headerParameters = [
            "accept": "*/*",
            "Content-Type": "application/json",
            "Authorization": "Bearer \(TokenManager.shared.getToken())",
            "x-api-key": apiKey
        ]
        
        return Endpoint(
            path: "api/auth/logout",
            method: .post,
            headerParameters: headerParameters
        )
    }
    
    /// Register
    static func register(with registerRequestDto: RegisterRequestDTO) -> Endpoint<RegisterResponseDTO> {

        return Endpoint(
            path: "3/search/movie",
            method: .get,
            queryParametersEncodable: registerRequestDto
        )
    }
    
    // MARK: - Chat Endpoints
    /// Chat Contacts
    static func getChatContacts(with chatContactsRequestDTO: ChatContactsRequestDTO) -> Endpoint<BaseResponse<[ChatContactResponseDTO]>> {
        let headerParameters = [
            "accept": "*/*",
            "Content-Type": "application/json",
            "Authorization": "Bearer \(TokenManager.shared.getToken())",
            "x-api-key": apiKey
        ]
        
        return Endpoint(
            path: "api/contact/",
            method: .get,
            headerParameters: headerParameters,
            queryParametersEncodable: chatContactsRequestDTO
        )
    }
    
    /// ...Additionally add function to fetch user profile image if needed
        
}
