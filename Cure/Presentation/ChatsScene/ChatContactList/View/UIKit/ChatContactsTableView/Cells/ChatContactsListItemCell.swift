//
//  ChatContactsListItemCell.swift
//  Cure
//
//  Created by MacBook Air MII  on 28/5/25.
//

import UIKit

import UIKit

final class ChatContactsListItemCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: ChatContactsListItemCell.self)
    static let height = CGFloat(80)

    private var viewModel: ChatContactsListItemViewModel!
    private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() } }
    private let mainQueue: DispatchQueueType = DispatchQueue.main

    // MARK: - UI Components
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    // MARK: - Setup
    private func setupViews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(subtitleLabel)

        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),

            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),

            subtitleLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4)
        ])
    }

    // MARK: - Fill Cell
    func fill(with viewModel: ChatContactsListItemViewModel) {
        self.viewModel = viewModel
        nameLabel.text = viewModel.contactName
        subtitleLabel.text = viewModel.channelIdUrl
        updateProfileImage()
    }

    private func updateProfileImage() {
        profileImageView.image = nil
        guard let imagePath = viewModel.profileImage else { return }

//        imageLoadTask = viewModel.imageLoader?.fetchImage(with: imagePath, width: 100) { [weak self] result in
//            self?.mainQueue.async {
//                if case let .success(data) = result {
//                    self?.profileImageView.image = UIImage(data: data)
//                }
//                self?.imageLoadTask = nil
//            }
//        }
    }
}
