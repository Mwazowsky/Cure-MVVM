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

@available(iOS 13.0.0, *)
struct ListChatContacts: View {
    @ObservedObject var viewModelWrapper: ChatContactsViewModelWrapper
    
    var body: some View {
        List(viewModelWrapper.items) { item in
            ChatContactsListItemView(viewModel: item)
        }
        .listStyle(PlainListStyle())
        .padding(.top, 4)
    }
}

@available(iOS 13.0.0, *)
struct ChatContactsListItemView: View {
    let viewModel: ChatContactsListItemViewModel
    
    var body: some View {
        HStack(spacing: 8) {
            AvatarIVCURE(imageUrl: URL(string: viewModel.profileImage ?? "https://picsum.photos/200")!)
                .frame(width: 64, height: 64)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.contactName)
                    .font(.headline)
                Text(viewModel.lastMessage)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .layoutPriority(1)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(String(viewModel.dateTime.prefix(4)))
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(viewModel.id)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity)
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
