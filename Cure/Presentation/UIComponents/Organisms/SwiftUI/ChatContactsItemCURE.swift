//
//  ChatContactsItemView.swift
//  Cure
//
//  Created by MacBook Air MII  on 14/5/25.
//

import SwiftUI

@available(iOS 13.0.0, *)
struct ChatContactsItemView: View {
    let viewModel: ChatContactsListItemViewModel
    
    var body: some View {
        HStack(spacing: 8) {
            AvatarIVCURE(imageUrl: URL(string: viewModel.profileImage ?? "https://picsum.photos/200")!)
                .frame(width: 64, height: 64)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.contactName)
                    .font(.headline)
                
                Text(viewModel.company)
                    .font(.caption)
                    .foregroundColor(DesignTokens.Colors.textBackground)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(DesignTokens.Colors.companyChip)
                    .cornerRadius(25)
                
                HStack {
                    Text(String(viewModel.channelIdUrl))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text(viewModel.lastMessage)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .layoutPriority(1)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(viewModel.dayOrTime)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                // Change with read indicator
                //                Text(viewModel.id)
                //                    .font(.subheadline)
                //                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
