//
//  SearchFormCURE.swift
//  Cure
//
//  Created by MacBook Air MII  on 8/5/25.
//

import SwiftUI

@available(iOS 13.0.0, *)
struct SearchFormCURE: View {
    @State private var searchQuery: String = ""
    var onSearch: (String) -> Void
    
    var body: some View {
        HStack {
            PrimaryTxtCURE(text: "Search")
            DefaultTFCURE(query: $searchQuery, placeholder: "Enter text...")
            SearchBtnCURE {
                onSearch(searchQuery)
            }
        }
        .padding()
    }
}
