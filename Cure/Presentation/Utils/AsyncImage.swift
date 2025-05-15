//
//  AsyncImage.swift
//  Cure
//
//  Created by MacBook Air MII  on 15/5/25.
//

import SwiftUI
import UIKit

@available(iOS 13.0, *)
struct AsyncImageView: UIViewRepresentable {
    let url: URL?
    
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        guard let url = url else {
            uiView.image = nil
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    uiView.image = image
                }
            }
        }.resume()
    }
}
