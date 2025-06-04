//
//  FilterChipsItemCell.swift
//  Cure
//
//  Created by MacBook Air MII  on 4/6/25.
//

import UIKit

class FilterChipsItemCell: UITableViewCell {
    static let reuseIdentifier = String(describing: FilterChipsItemCell.self)
    
    private var viewModel: ChatContactsListItemViewModel!
    
    private var chipFilterVC: ChipFilterCollectionViewController?
    
    //    var onFilterSelected: ((FilterType) -> Void)?
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupController()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupController()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        chipFilterVC?.view.clipsToBounds = true
    }
    
    // MARK: - Setup
    private func setupController() {
        chipFilterVC = ChipFilterCollectionViewController()
        guard let vc = chipFilterVC else { return }
        
        // Add its view as a subview
        contentView.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            vc.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            vc.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            vc.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    // MARK: - Fill Cell
    //    func fill(with viewModel: ChatContactsListItemViewModel) {
    //        self.viewModel = viewModel
    //        chipsLabel.text = "AAAAA"
    ////        companyLabel.text = viewModel.company
    //    }
}
