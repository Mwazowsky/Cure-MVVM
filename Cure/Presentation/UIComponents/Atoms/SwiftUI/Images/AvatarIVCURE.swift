//
//  AvatarImageViewCURE.swift
//  Cure
//
//  Created by MacBook Air MII  on 14/5/25.
//

import SwiftUI
import Kingfisher

@available(iOS 13.0.0, *)
struct AvatarIVCURE: View {
    let imageUrl: URL
    
    var body: some View {
        if #available(iOS 14.0, *) {
            KFImage(imageUrl)
                .resizable()
                .roundCorner(
                    radius: .widthFraction(0.8),
                    roundingCorners: [.topLeft, .bottomRight, .topRight, .bottomLeft]
                )
                .serialize(as: .PNG)
                .onSuccess { result in
                }
                .onFailure { error in
                }
                .frame(width: 64, height: 64)
        } else {
            AsyncImageView(url: imageUrl)
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 32))
        }
    }
}
