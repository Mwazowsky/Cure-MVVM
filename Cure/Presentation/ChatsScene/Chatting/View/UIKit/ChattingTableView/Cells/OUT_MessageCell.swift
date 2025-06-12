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
    
    private let bubbleShadowContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .top
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    private let messageBubble: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews(format: .textMessage)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews(format: .textMessage)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
        timeLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews(format: viewModel.contentFormat)
    }
    
    // MARK: - Labels
    private let messageLabel: UITextView = {
        let label =  UITextView()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .left
        label.dataDetectorTypes = UIDataDetectorTypes.all
        label.textColor = DesignTokens.LegacyColors.textForeground
        label.backgroundColor = .clear
        label.isEditable = false
        label.isScrollEnabled = false
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
    
    private func setupViews(format: MessageContentFormat) {
        guard let avatarUI = contactAvatar else { return }
        
        avatarUI.translatesAutoresizingMaskIntoConstraints = false
        
        bubbleShadowContainer.translatesAutoresizingMaskIntoConstraints = false
        messageBubble.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bubbleShadowContainer.addSubview(messageBubble)
        messageBubble.addSubview(messageLabel)
        messageBubble.addSubview(timeLabel)
        
        messageLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        messageLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        timeLabel.setContentHuggingPriority(.required, for: .horizontal)
        timeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        NSLayoutConstraint.activate([
            messageBubble.topAnchor.constraint(equalTo: bubbleShadowContainer.topAnchor),
            messageBubble.bottomAnchor.constraint(equalTo: bubbleShadowContainer.bottomAnchor),
            messageBubble.trailingAnchor.constraint(equalTo: bubbleShadowContainer.trailingAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: messageBubble.topAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: messageBubble.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: messageBubble.trailingAnchor, constant: -40),
            messageLabel.bottomAnchor.constraint(lessThanOrEqualTo: messageBubble.bottomAnchor, constant: -8),
            
            timeLabel.trailingAnchor.constraint(equalTo: messageBubble.trailingAnchor, constant: -8),
            timeLabel.bottomAnchor.constraint(equalTo: messageBubble.bottomAnchor, constant: -6),
            timeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: messageLabel.trailingAnchor, constant: 4)
        ])
        
        messageBubble.backgroundColor = DesignTokens.LegacyColors.primary.withAlphaComponent(0.8)
        messageBubble.layer.cornerRadius = 14
        messageBubble.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner,
            .layerMinXMaxYCorner
        ]
        messageBubble.layer.masksToBounds = true
        
        messageLabel.textContainerInset = .zero
        messageLabel.textContainer.lineFragmentPadding = 0
        
//        mainStackView.addArrangedSubview(avatarUI)
        mainStackView.addArrangedSubview(bubbleShadowContainer)
        
        contentView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            bubbleShadowContainer.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            
            messageLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.65),
        ])
    }
    
    
    func configure(with messageViewModel: ChattingListItemViewModel) {
        self.viewModel = messageViewModel
        
        
        if let employeeName = viewModel.employeeName {
            self.contactAvatar = AvatarNameCUREUIKit(name: employeeName)
            
            if let avatar = contactAvatar, avatar.superview == nil {
                mainStackView.addArrangedSubview(avatar)
            }
        } else {
//            contactAvatar?.removeFromSuperview()
            contactAvatar = nil
        }
        
        messageLabel.text = messageViewModel.messageContent
        timeLabel.text = messageViewModel.recievedAt
        setupViews(format: messageViewModel.contentFormat)
    }
}
