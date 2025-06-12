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
    case info     = "ChattingInfoCell"
}

enum MessageContentFormat: String {
    case sessionBubble      = "bubble"
    case textMessage        = "text"
    case audioMessage       = "audio"
    case stickerMessage     = "sticker"
    case templateMessage    = "template"
}

final class ChattingTableViewController: UITableViewController {
    private var delegate: ChattingViewControllerDelegate?
    
    // MARK: - Labels
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = DesignTokens.LegacyColors.textForeground
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    public var grouping: Bool = true
    public var grouping_interval: Double = 60
    public var scrollHeader = true
    public var showWeekDayHeader = true
    public var showNickName = true
    
    fileprivate var NICK_NAME_HEIGHT:CGFloat = 24
    
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
        DispatchQueue.main.async(execute: { () -> Void in
            self.tableView.reloadData()
        })
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
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.tableHeaderView?.addSubview(countLabel)
        
        countLabel.text = "\(viewModel.items.value.count)"
        
        tableView.register(IN_MessageCell.self, forCellReuseIdentifier: MessageBubbleType.incoming.rawValue)
        tableView.register(OUT_MessageCell.self, forCellReuseIdentifier: MessageBubbleType.outgoing.rawValue)
        tableView.register(ChattingInfoCell.self, forCellReuseIdentifier: MessageBubbleType.info.rawValue)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        
        tableView.layer.cornerRadius = 25
        tableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        tableView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ChattingTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reversedIndex = viewModel.items.value.count - 1 - indexPath.row
        let message = viewModel.items.value[reversedIndex]
        
        let contentFormat = message.contentFormat
        
        var identifier: String
        
        if contentFormat == .sessionBubble {
            identifier = MessageBubbleType.info.rawValue
        } else {
            identifier = message.direction == .incoming ? MessageBubbleType.incoming.rawValue : MessageBubbleType.outgoing.rawValue
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? MessageCell else {
            assertionFailure("Cannot dequeue reusable cell \(identifier) with reuseIdentifier: \(identifier)")
            return UITableViewCell()
        }
        
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        cell.configure(with: message)
        
        if indexPath.row == viewModel.items.value.count - 1 {
            viewModel.didLoadNextPage()
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
    }
}
