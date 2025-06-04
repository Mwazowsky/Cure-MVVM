//
//  ChatContactsTableView.swift
//  Cure
//
//  Created by MacBook Air MII  on 28/5/25.
//

import Foundation
import UIKit

final class ChatContactsTableViewController: UITableViewController {
    
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
        tableView.register(FilterChipsItemCell.self, forCellReuseIdentifier: FilterChipsItemCell.reuseIdentifier)
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        tableView.layer.cornerRadius = 25
        tableView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        tableView.layer.masksToBounds = true
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ChatContactsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: FilterChipsItemCell.reuseIdentifier,
                for: indexPath
            ) as? FilterChipsItemCell else {
                assertionFailure("Cannot dequeue reusable cell \(FilterChipsItemCell.self) with reuseIdentifier: \(FilterChipsItemCell.reuseIdentifier)")
                return UITableViewCell()
            }
            
//            cell.fill(with: viewModel.items.value[indexPath.row])
            
//            cell.onFilterSelected = { [weak self] selectedFilter in
//                self?.viewModel.applyFilter(selectedFilter)
//            }
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ChatContactsListItemCell.reuseIdentifier,
                for: indexPath
            ) as? ChatContactsListItemCell else {
                assertionFailure("Cannot dequeue reusable cell \(ChatContactsListItemCell.self) with reuseIdentifier: \(ChatContactsListItemCell.reuseIdentifier)")
                return UITableViewCell()
            }
            
            cell.fill(with: viewModel.items.value[indexPath.row - 1])
            
            if indexPath.row == viewModel.items.value.count - 1 {
                viewModel.didLoadNextPage()
            }
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 60 : 85
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row > 0 else { return }
        let contactIndex = indexPath.row - 1
        viewModel.didSelectItem(at: contactIndex)
    }
}
