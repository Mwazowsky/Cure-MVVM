//
//  AuthFieldsGroupCURE.swift
//  Cure
//
//  Created by MacBook Air MII  on 14/5/25.
//

import SwiftUI

@available(iOS 13.0.0, *)
struct AuthFieldsGroupCURE: View {
    @ObservedObject var viewModelWrapper: LoginViewModelWrapper
    
    var body: some View {
        VStack(spacing: 10) {
            DefaultTFCURE(
                isSecureTF: false,
                placeholder: "Email",
                text: binding(viewModelWrapper.viewModel?.email ?? Observable("")) { viewModelWrapper.viewModel?.updateEmail($0) },
                onTextChange: { viewModelWrapper.viewModel?.updateEmail($0) }
            )
            
            DefaultTFCURE(
                isSecureTF: true,
                placeholder: "Password",
                text: binding(viewModelWrapper.viewModel?.password ?? Observable("")) { viewModelWrapper.viewModel?.updatePassword($0) },
                onTextChange: { viewModelWrapper.viewModel?.updatePassword($0) }
            )
        }
    }
    
    func binding<T>(_ observable: Observable<T>, onChange: @escaping (T) -> Void) -> Binding<T> {
        Binding<T>(
            get: { observable.value },
            set: { newValue in
                onChange(newValue)
            }
        )
    }
}
