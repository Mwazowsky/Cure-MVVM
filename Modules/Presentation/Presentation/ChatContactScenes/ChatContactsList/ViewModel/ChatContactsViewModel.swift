//
//  ChatContactsViewModel.swift
//  Presentation
//
//  Created by MacBook Air MII  on 28/5/25.
//

import Foundation
import Common
import Domain

public enum ChatContactsViewRoute {
    case showChattingView
    case showChatContactQueriesSuggestions
    case closeChatContactQueriesSuggestions
}

public protocol ChatContactsViewRouter {
    func perform(_ segue: ChatContactsViewRoute)
}
//
//public class ChatContactsViewModel {
//    public enum LoadingType {
//        case none
//        case fullScreen
//        case nextPage
//    }
//    
//    private(set) var currentPage: Int = 0
//    private(set) var totalPageCount: Int = 1
//    
//    var hasMorePages: Bool {
//        return currentPage < totalPageCount
//    }
//    var nextPage: Int {
//        guard hasMorePages else { return currentPage }
//        return currentPage + 1
//    }
//    
//    public var router: ChatContactsViewRouter?
//    private let searchChatContactsUseCase: SearchChatContactsUseCase
//}
