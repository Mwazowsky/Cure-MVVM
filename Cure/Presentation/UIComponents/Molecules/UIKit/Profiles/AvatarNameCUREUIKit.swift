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
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20 // Half of 24 to make it circular
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
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
        self.translatesAutoresizingMaskIntoConstraints = false
        avatar.image = UIImage(named: "profile-placeholder")
        nameLabel.text = name
        
        addSubview(avatar)
        addSubview(nameLabel)
        
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        avatar.setContentHuggingPriority(.required, for: .horizontal)
        
        NSLayoutConstraint.activate([
            trailingAnchor.constraint(equalTo: avatar.trailingAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: avatar.leadingAnchor, constant: -8),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            avatar.widthAnchor.constraint(equalToConstant: 40),
            avatar.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
