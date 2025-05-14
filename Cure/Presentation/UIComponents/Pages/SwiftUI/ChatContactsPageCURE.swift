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
    
    let animalList = Animal.preview()
    
    var body: some View {
        MainLayoutCURE {
            List {
                ForEach(animalList) { animal in
                    Text(animal.name)
                        .listRowInsets(EdgeInsets())
                        .padding(.horizontal, 10)
                }
            }
            .listStyle(PlainListStyle())
        }
    }
}

struct Animal: Identifiable {
    var id = UUID()
    var name: String
    
    static func preview() -> [Animal] {
        return [
            Animal(name: "Cat"),
            Animal(name: "Goat"),
            Animal(name: "Camel"),
            Animal(name: "Penguin"),
            Animal(name: "Lion"),
            Animal(name: "Tiger"),
            Animal(name: "Eagle"),
            Animal(name: "Snake"),
            Animal(name: "Capybara")
        ]
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
