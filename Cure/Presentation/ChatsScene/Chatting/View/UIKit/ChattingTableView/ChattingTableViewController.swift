//
//  ChattingTableView.swift
//  Cure
//
//  Created by MacBook Air MII  on 3/6/25.
//

import Foundation
import UIKit

protocol MessageCell: UITableViewCell {
    func configure(with messageViewModel: ChattingListItemViewModel)
}

enum MessageBubbleType: String {
    case incoming = "IN_MessageCell"
    case outgoing = "OUT_MessageCell"
}

final class ChattingTableViewController: UITableViewController {
    private var shouldResize: Bool = true
    
    private var delegate: ChattingViewControllerDelegate?
    
    var viewModel: ChattingViewModel! {
        didSet {
            self.reload()
        }
    }
    
    var nextPageLoadingSpinner: UIActivityIndicatorView?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    func updateLoading(_ loading: ChattingViewModelLoading?) {
        switch loading {
        case .nextPage:
            nextPageLoadingSpinner?.removeFromSuperview()
            nextPageLoadingSpinner = makeActivityIndicator(size: .init(width: tableView.frame.width, height: 44))
            tableView.tableFooterView = nextPageLoadingSpinner
        case .fullscreen, .none:
            tableView.tableFooterView = nil
        }
    }
    
    // MARK: - Private
    private func setupViews() {
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 78, bottom: 0, right: 16)
        
        tableView.register(IN_MessageCell.self, forCellReuseIdentifier: MessageBubbleType.incoming.rawValue)
        tableView.register(OUT_MessageCell.self, forCellReuseIdentifier: MessageBubbleType.outgoing.rawValue)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        tableView.layer.cornerRadius = 25
        tableView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        tableView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Scroll View Delegates
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if shouldResize {
            self.delegate?.moveAndResizeImageForPortrait()
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ChattingTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = viewModel.items.value[indexPath.row]
        let identifier = message.direction == .incoming ? MessageBubbleType.incoming.rawValue : MessageBubbleType.outgoing.rawValue
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? MessageCell else {
            assertionFailure("Cannot dequeue reusable cell \(identifier) with reuseIdentifier: \(identifier)")
            return UITableViewCell()
        }
        
        cell.configure(with: message)
        
        if indexPath.row == viewModel.items.value.count - 1 {
            viewModel.didLoadNextPage()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
    }
}
