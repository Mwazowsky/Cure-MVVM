//
//  ChattingMessageCell.swift
//  Cure
//
//  Created by MacBook Air MII  on 3/6/25.
//

import UIKit
import Kingfisher

final class OUT_MessageCell: UITableViewCell, MessageCell {
    static let reuseIdentifier = String(describing: OUT_MessageCell.self)
    
    private var viewModel: ChattingListItemViewModel!
    
    // MARK: - UI Components
    /// Custom UI
    private var contactAvatar: AvatarNameCUREUIKit? {
        didSet {
            oldValue?.removeFromSuperview()
        }
    }
    
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
        guard let avatarUI = contactAvatar else { return }
        contentView.addSubview(bubbleShadowContainer)
        contentView.addSubview(avatarUI)
        bubbleShadowContainer.addSubview(messageBubble)
        messageBubble.addSubview(messageLabel)
        messageBubble.addSubview(timeLabel)
        
        bubbleShadowContainer.translatesAutoresizingMaskIntoConstraints = false
        messageBubble.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        messageBubble.backgroundColor = DesignTokens.LegacyColors.primary.withAlphaComponent(0.8)
        messageBubble.layer.maskedCorners = [
            .layerMinXMinYCorner,  // top-left
            .layerMaxXMinYCorner,  // top-right
            .layerMinXMaxYCorner   // bottom-left
        ]
        
        messageBubble.layer.cornerRadius = 14
        messageBubble.layer.masksToBounds = true
        
        
        messageLabel.numberOfLines = 0
        
        let constraints: [NSLayoutConstraint] = [
            avatarUI.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            avatarUI.bottomAnchor.constraint(equalTo: bubbleShadowContainer.topAnchor, constant: -16),
            avatarUI.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            
            messageBubble.topAnchor.constraint(equalTo: bubbleShadowContainer.topAnchor),
            messageBubble.bottomAnchor.constraint(equalTo: bubbleShadowContainer.bottomAnchor),
            messageBubble.leadingAnchor.constraint(equalTo: bubbleShadowContainer.leadingAnchor),
            messageBubble.trailingAnchor.constraint(equalTo: bubbleShadowContainer.trailingAnchor),
            
            bubbleShadowContainer.topAnchor.constraint(equalTo: avatarUI.topAnchor, constant: 16),
            bubbleShadowContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            bubbleShadowContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
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
        
        self.contactAvatar = AvatarNameCUREUIKit(name: viewModel.id)
        
        // Make sure to add to contentView if not already done
        if let avatar = contactAvatar, avatar.superview == nil {
            contentView.addSubview(avatar)
            // Set up avatar constraints relative to bubbleShadowContainer
        }
        
        messageLabel.text = messageViewModel.messageContent
        timeLabel.text = messageViewModel.recievedAt
        setupViews(direction: messageViewModel.direction, format: messageViewModel.contentFormat)
    }
}
