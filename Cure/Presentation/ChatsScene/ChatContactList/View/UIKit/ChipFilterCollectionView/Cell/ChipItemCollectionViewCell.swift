//
//  ChipItemCollectionViewCell.swift
//  Cure
//
//  Created by MacBook Air MII  on 4/6/25.
//

import UIKit

class ChipItemCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: ChipItemCollectionViewCell.self)
    
    private var viewModel: ChatContactsListItemViewModel!
    
    private let chipsLabelContainer: UIView = {
        let view = UIView()
        view.backgroundColor = DesignTokens.LegacyColors.secondary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Labels
    private let chipsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = DesignTokens.LegacyColors.textForeground
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    //    var onFilterSelected: ((FilterType) -> Void)?
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Setup
    private func setupViews() {
        chipsLabel.numberOfLines = 0
        chipsLabel.text = "AAAAAA"
        
        contentView.contentHuggingPriority(for: .horizontal)
        
        contentView.addSubview(chipsLabelContainer)
        chipsLabelContainer.addSubview(chipsLabel)
        
        chipsLabelContainer.layer.masksToBounds = false
        chipsLabelContainer.layer.shadowRadius = 5
        chipsLabelContainer.layer.shadowOpacity = 1
        chipsLabelContainer.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
        chipsLabelContainer.layer.shadowOffset = CGSize(width: 0 , height: 1)
        chipsLabelContainer.layer.cornerRadius = 19
        
        NSLayoutConstraint.activate([
            chipsLabel.topAnchor.constraint(equalTo: chipsLabelContainer.topAnchor, constant: 8),
            chipsLabel.bottomAnchor.constraint(equalTo: chipsLabelContainer.bottomAnchor, constant: -8),
            chipsLabel.leadingAnchor.constraint(equalTo: chipsLabelContainer.leadingAnchor, constant: 12),
            chipsLabel.trailingAnchor.constraint(equalTo: chipsLabelContainer.trailingAnchor, constant: -12)
        ])
        
        
        NSLayoutConstraint.activate([
            chipsLabelContainer.heightAnchor.constraint(equalToConstant: 38),
            chipsLabelContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            chipsLabelContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            chipsLabelContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    // MARK: - Fill Cell
    //    func fill(with viewModel: ChatContactsListItemViewModel) {
    //        self.viewModel = viewModel
    //        chipsLabel.text = "AAAAA"
    ////        companyLabel.text = viewModel.company
    //    }
}
