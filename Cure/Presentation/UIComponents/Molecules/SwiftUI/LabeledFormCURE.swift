//
//  SearchFormCURE.swift
//  Cure
//
//  Created by MacBook Air MII  on 8/5/25.
//

import SwiftUI

@available(iOS 13.0.0, *)
struct LabeledFormCURE: View {
    @State private var inputText: String = ""
    var label: String
    
    var body: some View {
        HStack {
            SecondaryTxtCURE(text: label)
//            DefaultTFCURE(
//                query: $inputText,
//                placeholder: "Enter \(label)"
//            )
        }
        .padding()
    }
}
