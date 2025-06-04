//
//  ChipFilterCollectionViewController.swift
//  Cure
//
//  Created by MacBook Air MII  on 4/6/25.
//

import UIKit

class ChipFilterCollectionViewController: UIViewController {
    static let cellIdentifier = String(describing: ChipFilterCollectionViewController.self)
    
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var layout = UICollectionViewLayout()
        
        if #available(iOS 13.0, *) {
            layout = createCompositionalLayout()
        } else {
            layout = UICollectionViewFlowLayout()
        }
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        collectionView.register(ChipItemCollectionViewCell.self, forCellWithReuseIdentifier: ChipItemCollectionViewCell.reuseIdentifier)
        collectionView.register(BadgeSupplementaryView.self,
                                forSupplementaryViewOfKind: BadgeSupplementaryView.kind,
                                withReuseIdentifier: BadgeSupplementaryView.reuseIdentifier)

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    @available(iOS 13.0, *)
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .estimated(100),
                heightDimension: .absolute(40)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: -5, trailing: 5)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .estimated(1000),
                heightDimension: .absolute(50)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 12, bottom: 5, trailing: 12)
            section.interGroupSpacing = 10

            section.orthogonalScrollingBehavior = .continuous
            
            return section
        }
    }
}

extension ChipFilterCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ChipItemCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? ChipItemCollectionViewCell else {
            assertionFailure("Cannot dequeue reusable cell \(ChipItemCollectionViewCell.self) with reuseIdentifier: \(ChipItemCollectionViewCell.reuseIdentifier)")
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let contactIndex = indexPath.row
//        viewModel.didSelectItem(at: contactIndex)
    }
}

class BadgeSupplementaryView: UICollectionReusableView {
    static let reuseIdentifier = "BadgeView"
    static let kind = "badge-kind"
    
    // MARK: - Labels
    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = DesignTokens.LegacyColors.textForeground
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemRed
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        badgeLabel.text = "21"
    }
}
