//
//  UINavigationController+AddLogoImage.swift
//  Cure
//
//  Created by MacBook Air MII  on 2/6/25.
//

import UIKit
import Kingfisher

extension UINavigationController {
    func addLogoImage(imagePath: String, navItem: UINavigationItem) {
        guard let profileImageUrl = URL(string: imagePath) else {
            print("Invalid URL string for image path: \(imagePath)")
            return
        }
        
        let containerSize: CGFloat = 44

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = containerSize / 2
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: containerSize, height: containerSize))
        containerView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: containerSize),
            imageView.heightAnchor.constraint(equalToConstant: containerSize)
        ])

        let processor = DownsamplingImageProcessor(size: CGSize(width: containerSize, height: containerSize))
            |> RoundCornerImageProcessor(cornerRadius: containerSize / 2)

        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: profileImageUrl,
            placeholder: UIImage(named: "profile-placeholder"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ]
        ) { result in
            switch result {
            case .success(let value):
                print("Image loaded from: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Image load failed: \(error.localizedDescription)")
            }
        }

        navItem.titleView = containerView
    }
}
