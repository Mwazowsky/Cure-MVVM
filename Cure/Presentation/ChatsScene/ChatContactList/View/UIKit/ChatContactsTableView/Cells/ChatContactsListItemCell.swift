//
//  ChatContactsListItemCell.swift
//  Cure
//
//  Created by MacBook Air MII  on 28/5/25.
//

import UIKit
import Kingfisher

final class ChatContactsListItemCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: ChatContactsListItemCell.self)

    private var viewModel: ChatContactsListItemViewModel!

    // MARK: - UI Components
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let mainVStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let secondaryVStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .trailing
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let companyLabelContainer: UIView = {
        let view = UIView()
        view.backgroundColor = DesignTokens.LegacyColors.companyChipBG
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Labels
    private let companyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = DesignTokens.LegacyColors.lightBackground
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

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
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
        nameLabel.numberOfLines = 0
        subtitleLabel.numberOfLines = 0
        companyLabelContainer.setContentHuggingPriority(.required, for: .vertical)
        companyLabelContainer.setContentCompressionResistancePriority(.required, for: .vertical)
        
        companyLabelContainer.layer.masksToBounds = false
        companyLabelContainer.layer.shadowRadius = 5
        companyLabelContainer.layer.shadowOpacity = 1
        companyLabelContainer.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
        companyLabelContainer.layer.shadowOffset = CGSize(width: 0 , height: 1)
        companyLabelContainer.layer.cornerRadius = 10
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(mainVStackView)
        contentView.addSubview(secondaryVStackView)

        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),

            mainVStackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            mainVStackView.trailingAnchor.constraint(equalTo: secondaryVStackView.trailingAnchor),
            mainVStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainVStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            secondaryVStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            secondaryVStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            secondaryVStackView.leadingAnchor.constraint(equalTo: mainVStackView.leadingAnchor, constant: 4),
            secondaryVStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
        ])
        
        companyLabelContainer.addSubview(companyLabel)
        
        NSLayoutConstraint.activate([
            companyLabel.topAnchor.constraint(equalTo: companyLabelContainer.topAnchor, constant: 4),
            companyLabel.bottomAnchor.constraint(equalTo: companyLabelContainer.bottomAnchor, constant: -4),
            companyLabel.leadingAnchor.constraint(equalTo: companyLabelContainer.leadingAnchor, constant: 8),
            companyLabel.trailingAnchor.constraint(equalTo: companyLabelContainer.trailingAnchor, constant: -8)
        ])
        
        mainVStackView.addArrangedSubview(nameLabel)
        mainVStackView.addArrangedSubview(companyLabelContainer)
        mainVStackView.addArrangedSubview(subtitleLabel)
        
        secondaryVStackView.addArrangedSubview(timeLabel)
    }

    // MARK: - Fill Cell
    func fill(with viewModel: ChatContactsListItemViewModel) {
        self.viewModel = viewModel
        nameLabel.text = viewModel.contactName
        companyLabel.text = viewModel.company
        subtitleLabel.text = viewModel.channelIdUrl
        timeLabel.text = viewModel.dayOrTime
        updateProfileImage()
    }

    private func updateProfileImage() {
        profileImageView.image = UIImage(named: "profile-placeholder")
        
        guard let imagePath = viewModel.profileImage else { return }
        
        let profileImageUrl = URL(string: imagePath)

        let processor = DownsamplingImageProcessor(size: profileImageView.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 20)
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(
            with: profileImageUrl,
            placeholder: UIImage(named: "profile-placeholder"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
}
