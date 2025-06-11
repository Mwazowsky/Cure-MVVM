//
//  ChattingMessageCell.swift
//  Cure
//
//  Created by MacBook Air MII  on 3/6/25.
//

import UIKit
import Kingfisher

final class IN_MessageCell: UITableViewCell, MessageCell {
    static let reuseIdentifier = String(describing: IN_MessageCell.self)
    
    private var viewModel: ChattingListItemViewModel!
    
    // MARK: - UI Components
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let bubbleShadowContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let messageBubble: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Labels
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = DesignTokens.LegacyColors.textForeground
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 9, weight: .thin)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - Setup
    private func setupViews(direction: MessageDirection, format: MessageContentFormat) {
        contentView.addSubview(bubbleShadowContainer)
        bubbleShadowContainer.addSubview(messageBubble)
        messageBubble.addSubview(messageLabel)
        messageBubble.addSubview(timeLabel)
        
        timeLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        timeLabel.textColor = UIColor(white: 0.6, alpha: 1.0)
        timeLabel.textAlignment = .right
        
        bubbleShadowContainer.translatesAutoresizingMaskIntoConstraints = false
        messageBubble.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        messageBubble.backgroundColor = DesignTokens.LegacyColors.secondary
        messageBubble.layer.maskedCorners = [
            .layerMinXMinYCorner,  // top-left
            .layerMaxXMinYCorner,  // top-right
            .layerMaxXMaxYCorner   // bottom-right
        ]
        messageBubble.layer.cornerRadius = 14
        messageBubble.layer.masksToBounds = true
        
        messageLabel.numberOfLines = 0
        
        let constraints: [NSLayoutConstraint] = [
            messageBubble.topAnchor.constraint(equalTo: bubbleShadowContainer.topAnchor),
            messageBubble.bottomAnchor.constraint(equalTo: bubbleShadowContainer.bottomAnchor),
            messageBubble.leadingAnchor.constraint(equalTo: bubbleShadowContainer.leadingAnchor),
            messageBubble.trailingAnchor.constraint(equalTo: bubbleShadowContainer.trailingAnchor),
            
            bubbleShadowContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            bubbleShadowContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            bubbleShadowContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            bubbleShadowContainer.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
            bubbleShadowContainer.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.75),
            bubbleShadowContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            
            messageLabel.topAnchor.constraint(equalTo: messageBubble.topAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: messageBubble.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: messageBubble.trailingAnchor, constant: -40),
            messageLabel.bottomAnchor.constraint(lessThanOrEqualTo: messageBubble.bottomAnchor, constant: -8),
            
            timeLabel.trailingAnchor.constraint(equalTo: messageBubble.trailingAnchor, constant: -8),
            timeLabel.bottomAnchor.constraint(equalTo: messageBubble.bottomAnchor, constant: -6),
            timeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: messageLabel.trailingAnchor, constant: 4),
            
            timeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: messageLabel.leadingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func configure(with messageViewModel: ChattingListItemViewModel) {
        self.viewModel = messageViewModel
        
        messageLabel.text = messageViewModel.messageContent
        timeLabel.text = messageViewModel.recievedAt
        setupViews(direction: messageViewModel.direction, format: messageViewModel.contentFormat)
    }
}
