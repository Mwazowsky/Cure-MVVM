//
//  ChatContactsListItemCell.swift
//  Cure
//
//  Created by MacBook Air MII  on 28/5/25.
//

import UIKit

final class ChatContactsListItemCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: ChatContactsListItemCell.self)
    static let height = CGFloat(130)
    
    private var viewModel: ChatContactsListItemViewModel!
    private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() } }
    private let mainQueue: DispatchQueueType = DispatchQueue.main

    func fill(
        with viewModel: ChatContactsListItemViewModel
    ) {
        self.viewModel = viewModel

//        titleLabel.text = viewModel.title
//        dateLabel.text = viewModel.releaseDate
//        overviewLabel.text = viewModel.overview
//        updatePosterImage(width: Int(posterImageView.imageSizeAfterAspectFit.scaledSize.width))
    }

    private func updateProfileImage(width: Int) {
//        posterImageView.image = nil
//        guard let posterImagePath = viewModel.posterImagePath else { return }
//
//        imageLoadTask = posterImagesRepository?.fetchImage(
//            with: posterImagePath,
//            width: width
//        ) { [weak self] result in
//            self?.mainQueue.async {
//                guard self?.viewModel.posterImagePath == posterImagePath else { return }
//                if case let .success(data) = result {
//                    self?.posterImageView.image = UIImage(data: data)
//                }
//                self?.imageLoadTask = nil
//            }
//        }
    }
}
