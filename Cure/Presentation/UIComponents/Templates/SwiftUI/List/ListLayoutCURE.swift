//
//  ListLayoutCURE.swift
//  Cure
//
//  Created by MacBook Air MII  on 16/5/25.
//

import SwiftUI

@available(iOS 13.0.0, *)
struct ListChatContacts: View {
    @ObservedObject var viewModelWrapper: ChatContactsViewModelWrapper
    
    var body: some View {
        List(viewModelWrapper.items.indices, id: \.self) { index in
            ChatContactsItemView(
                viewModel: viewModelWrapper.items[index],
                onSelect: {
                    viewModelWrapper.viewModel?.didSelectItem(at: index)
                }
            )
        }
        .listStyle(PlainListStyle())
        .padding(.top, 4)
    }
}
