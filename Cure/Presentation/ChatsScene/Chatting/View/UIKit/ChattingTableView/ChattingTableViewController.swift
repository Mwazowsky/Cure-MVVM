//
//  ChattingTableView.swift
//  Cure
//
//  Created by MacBook Air MII  on 3/6/25.
//

import Foundation
import UIKit

final class ChattingTableViewController: UITableViewController {
    private var shouldResize: Bool = true
    
    private var delegate: ChattingViewControllerDelegate?
    
    var viewModel: ChatContactsViewModel! {
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
    
    func updateLoading(_ loading: ChatContactsViewModelLoading?) {
        switch loading {
        case .nextPage:
            nextPageLoadingSpinner?.removeFromSuperview()
            nextPageLoadingSpinner = makeActivityIndicator(size: .init(width: tableView.frame.width, height: 44))
            tableView.tableFooterView = nextPageLoadingSpinner
        case .fullScreen, .none:
            tableView.tableFooterView = nil
        }
    }
    
    // MARK: - Private
    private func setupViews() {
        tableView.estimatedRowHeight = 55
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 78, bottom: 0, right: 16)

        tableView.register(ChatContactsListItemCell.self, forCellReuseIdentifier: ChatContactsListItemCell.reuseIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        tableView.layer.cornerRadius = 25
        tableView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        tableView.layer.masksToBounds = true
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
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatContactsListItemCell.reuseIdentifier,
            for: indexPath
        ) as? ChatContactsListItemCell else {
            assertionFailure("Cannot dequeue reusable cell \(ChatContactsListItemCell.self) with reuseIdentifier: \(ChatContactsListItemCell.reuseIdentifier)")
            return UITableViewCell()
        }
        
        cell.fill(with: viewModel.items.value[indexPath.row])
        
        if indexPath.row == viewModel.items.value.count - 1 {
            viewModel.didLoadNextPage()
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
    }
}
