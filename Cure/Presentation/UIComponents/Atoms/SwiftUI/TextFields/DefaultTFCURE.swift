//
//  DefaultTFCURE.swift
//  Cure
//
//  Created by MacBook Air MII  on 8/5/25.
//

import SwiftUI
import Combine

@available(iOS 13.0.0, *)
struct DefaultTFCURE: View {
    var isSecureTF: Bool = false
    var placeholder: String
    @Binding var text: String
    var onTextChange: (String) -> Void
    
    @State private var debounceHelper = DebounceHelper()
    
    var body: some View {
        if !isSecureTF {
            TextField(placeholder, text: $text)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .onReceive(Just(text)) { newValue in
                    debounceHelper.input.send(newValue)
                }
                .onReceive(debounceHelper.output) { debouncedValue in
                    onTextChange(debouncedValue)
                }
        } else {
            SecureField(placeholder, text: $text)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .onReceive(Just(text)) { newValue in
                    debounceHelper.input.send(newValue)
                }
                .onReceive(debounceHelper.output) { debouncedValue in
                    onTextChange(debouncedValue)
                }
        }
    }
}

@available(iOS 13.0.0, *)
final class DebounceHelper: ObservableObject {
    let input = PassthroughSubject<String, Never>()
    @Published var outputValue: String = ""
    var output: AnyPublisher<String, Never>
    
    private var cancellables = Set<AnyCancellable>()
    
    init(interval: TimeInterval = 0.5) {
        output = input
            .debounce(for: .milliseconds(Int(interval * 1000)), scheduler: RunLoop.main)
            .removeDuplicates()
            .share()
            .eraseToAnyPublisher()
    }
}
