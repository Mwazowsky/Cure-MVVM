//
//  ChatContactsPage.swift
//  Cure
//
//  Created by MacBook Air MII  on 14/5/25.
//

import SwiftUI

@available(iOS 13.0.0, *)
struct ChatContactsPageCURE: View {
    let viewModelWrapper: ChatContactsViewModelWrapper
    
    var body: some View {
        MainLayoutCURE {
            ListChatContacts(viewModelWrapper: viewModelWrapper)
        }
    }
}

#if DEBUG
@available(iOS 13.0, *)
struct ChatContactsPageCURE_Previews: PreviewProvider {
    static var previews: some View {
        ChatContactsView(viewModelWrapper: previewViewModelWrapper)
    }
    
    static var previewViewModelWrapper: ChatContactsViewModelWrapper = {
        var viewModel = ChatContactsViewModelWrapper(viewModel: nil)
        return viewModel
    }()
}
#endif
