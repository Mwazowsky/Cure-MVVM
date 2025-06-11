//
//  AvatarWithName.swift
//  Cure
//
//  Created by MacBook Air MII  on 11/6/25.
//

import UIKit

final class AvatarNameCUREUIKit: UIView {
    private let avatar: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "profile-placeholder"))
        
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(name: String) {
        super.init(frame: .zero)
        self.configure(name: name)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(name: String) {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        
        avatar.image = UIImage(named: "profile-placeholder")
        nameLabel.text = name
        
        addSubview(avatar)
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            avatar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            avatar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            avatar.widthAnchor.constraint(equalTo: avatar.heightAnchor),
            avatar.trailingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: -4),
            
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4)
        ])
    }
}
