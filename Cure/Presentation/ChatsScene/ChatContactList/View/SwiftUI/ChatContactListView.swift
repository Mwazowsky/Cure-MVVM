//
//  LoginView.swift
//  Cure
//
//  Created by MacBook Air MII  on 8/5/25.
//

import SwiftUI

//@available(iOS 13.0, *)
//extension DefaultLoginViewModel: Identifiable { }

@available(iOS 13.0, *)
struct ChatContactsView: View {
    @ObservedObject var viewModelWrapper: ChatContactsViewModelWrapper

    var body: some View {
        ChatContactsPageCURE(viewModelWrapper: viewModelWrapper)
            .navigationBarHidden(false)
            .onAppear {
                viewModelWrapper.viewModel?.viewDidLoad()
            }
    }
}

@available(iOS 13.0, *)
final class ChatContactsViewModelWrapper: ObservableObject {
    var viewModel: ChatContactsViewModel?
    
    init(viewModel: ChatContactsViewModel?) {
        self.viewModel = viewModel
    }
}

#if DEBUG
@available(iOS 13.0, *)
struct ChatContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatContactsView(viewModelWrapper: previewViewModelWrapper)
    }
    
    static var previewViewModelWrapper: ChatContactsViewModelWrapper = {
        var viewModel = ChatContactsViewModelWrapper(viewModel: nil)
        
        return viewModel
    }()
}
#endif
