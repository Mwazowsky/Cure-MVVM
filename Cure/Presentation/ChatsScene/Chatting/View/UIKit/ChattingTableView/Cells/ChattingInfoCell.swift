//
//  ChattingInfoCell.swift
//  Cure
//
//  Created by MacBook Air MII  on 3/6/25.
//
import UIKit

final class ChattingInfoCell: UITableViewCell, MessageCell {
    static let reuseIdentifier = String(describing: ChattingInfoCell.self)
    
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
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - Setup
    private func setupViews(direction: MessageDirection, format: MessageContentFormat) {
        contentView.addSubview(bubbleShadowContainer)
        bubbleShadowContainer.addSubview(messageBubble)
        messageBubble.addSubview(messageLabel)
        
        bubbleShadowContainer.translatesAutoresizingMaskIntoConstraints = false
        messageBubble.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel.textAlignment = .center
        
        messageBubble.backgroundColor = UIColor(white: 0.93, alpha: 0.8)
        
        messageBubble.layer.cornerRadius = 8
        messageBubble.layer.masksToBounds = true
        
        messageLabel.numberOfLines = 2
        
        let constraints: [NSLayoutConstraint] = [
            messageLabel.topAnchor.constraint(equalTo: messageBubble.topAnchor, constant: 4),
            messageLabel.bottomAnchor.constraint(equalTo: messageBubble.bottomAnchor, constant: -4),
            messageLabel.leadingAnchor.constraint(equalTo: messageBubble.leadingAnchor, constant: 6),
            messageLabel.trailingAnchor.constraint(equalTo: messageBubble.trailingAnchor, constant: -6),
            
            messageBubble.topAnchor.constraint(equalTo: bubbleShadowContainer.topAnchor),
            messageBubble.bottomAnchor.constraint(equalTo: bubbleShadowContainer.bottomAnchor),
            messageBubble.leadingAnchor.constraint(equalTo: bubbleShadowContainer.leadingAnchor),
            messageBubble.trailingAnchor.constraint(equalTo: bubbleShadowContainer.trailingAnchor),
            
            bubbleShadowContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            bubbleShadowContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            bubbleShadowContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bubbleShadowContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            bubbleShadowContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func configure(with messageViewModel: ChattingListItemViewModel) {
        self.viewModel = messageViewModel
        
        messageLabel.text = messageViewModel.messageContent
        setupViews(direction: messageViewModel.direction, format: messageViewModel.contentFormat)
    }
}
