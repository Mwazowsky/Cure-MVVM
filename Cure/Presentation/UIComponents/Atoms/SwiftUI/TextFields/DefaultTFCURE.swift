//
//  DefaultTFCURE.swift
//  Cure
//
//  Created by MacBook Air MII  on 8/5/25.
//

import SwiftUI

@available(iOS 13.0.0, *)
struct DefaultTFCURE: View {
    @Binding var query: String
    var placeholder: String

    var body: some View {
        let binding = Binding<String>(
            get: { query },
            set: {
                query = $0
            }
        )

        return TextField(placeholder, text: binding)
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
    }
}

