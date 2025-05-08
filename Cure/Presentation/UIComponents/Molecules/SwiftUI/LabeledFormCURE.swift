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
//    var onChange: (String) -> Void
    
    var body: some View {
        HStack {
            PrimaryTxtCURE(text: label)
            DefaultTFCURE(
                query: $inputText,
                placeholder: "Enter \(label)"
//                onChange: onChange
            )
        }
        .padding()
    }
}
