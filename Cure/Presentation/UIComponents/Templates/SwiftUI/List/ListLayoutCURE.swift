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
        List(viewModelWrapper.items) { item in
            ChatContactsItemView(viewModel: item)
        }
        .listStyle(PlainListStyle())
        .padding(.top, 4)
    }
}
