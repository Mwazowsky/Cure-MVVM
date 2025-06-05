//
//  ReadyViewController.swift
//  Cure
//
//  Created by MacBook Air MII  on 27/3/25.
//

import UIKit

protocol ChatContactListViewControllerDelegate: AnyObject {
    func moveAndResizeImageForPortrait()
    func resizeImageForLandscape()
    func showImage(_ show: Bool)
}

extension ChatContactListViewController {
    /// WARNING: Change these constants according to your project's design
    private struct Const {
        static let navTitle: String = "Chats"
        /// Image height/width for Large NavBar state
        static let ImageSizeForLargeState: CGFloat = 60
        /// Margin from right anchor of safe area to right anchor of Image
        static let ImageRightMargin: CGFloat = 16
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
        static let ImageBottomMarginForLargeState: CGFloat = -12
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
        static let ImageBottomMarginForSmallState: CGFloat = -28
        /// Image height/width for Small NavBar state
        static let ImageSizeForSmallState: CGFloat = 40
        /// Height of NavBar for Small state. Usually it's just 44
        static let NavBarHeightSmallState: CGFloat = 60
        /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
        static let NavBarHeightLargeState: CGFloat = 96.5
        /// Image height/width for Landscape state
        static let ScaleForImageSizeForLandscape: CGFloat = 0.65
        
        static let ImageTopMargin: CGFloat = 6
    }
}

class ChatContactListViewController: UIViewController, Alertable {
    private var viewModel: ChatContactsViewModel!
    
    private let imageview: UIImageView = UIImageView(image: UIImage(named: "profile-placeholder"))
    private let searchController = UISearchController(searchResultsController: nil)
    private let parentView: UIView = UIView()
    
    private var chatContactsTableViewController: ChatContactsTableViewController?
    private var loadingView: UIActivityIndicatorView = UIActivityIndicatorView()
    private var emptyDataLabel: UILabel = UILabel()
    private(set) var suggestionsListContainer: UIView = {
        let view = UIView()
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .lightGray
        }
        
        return view
    }()
    
    var didSendEventClosure: ((ChatContactListViewController.Event) -> Void)?
    var filteredContacts: [ChatContactsListItemViewModel] = []
    var maxConsideredNavHeight: CGFloat = 96.5
    
    private var shouldResize: Bool = true
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    static func create(
        with viewModel: ChatContactsViewModel
    ) -> ChatContactListViewController {
        let view = ChatContactListViewController()
        
        view.viewModel = viewModel
        
        return view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        showImage(isShow: true, duration: 0.5)
        
        guard shouldResize else { return }
        
        if let searchController = navigationItem.searchController, searchController.isActive {
            return
        }
        
        moveAndResizeImageForPortrait()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showImage(isShow: false, duration: 0.5)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard shouldResize else { return }
        
        if let searchController = navigationItem.searchController, searchController.isActive {
            return
        }
        
        moveAndResizeImageForPortrait()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            //            let darkModeEnabled = KeychainWrapper.standard.string(forKey: "darkMode") == "true"
            //            view.backgroundColor = darkModeEnabled ? UIColor.black : UIColor.white
        }
        searchController.delegate = self
        
        setupUI()
        bind(to: viewModel)
        
        setupSearchController()
        
        self.chatContactsTableViewController = ChatContactsTableViewController()
        chatContactsTableViewController?.viewModel = viewModel
        
        viewModel.viewDidLoad()
        
        guard let chatContactsTVController = chatContactsTableViewController else { return }
        
        parentView.backgroundColor = DesignTokens.LegacyColors.primary
        parentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(parentView)
        
        NSLayoutConstraint.activate([
            parentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            parentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            parentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            parentView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        parentView.addSubview(chatContactsTVController.view)
        
        NSLayoutConstraint.activate([
            chatContactsTVController.view.topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor),
            chatContactsTVController.view.bottomAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.bottomAnchor),
            chatContactsTVController.view.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            chatContactsTVController.view.trailingAnchor.constraint(equalTo: parentView.trailingAnchor)
        ])
        
        chatContactsTableViewController?.didMove(toParent: self)
        self.chatContactsTableViewController = chatContactsTVController
    }
    
    private func setupUI() {
        self.maxConsideredNavHeight = navigationController?.navigationBar.frame.height ?? 96.5
        
        title = Const.navTitle
        
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(imageview)
        imageview.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        
        imageview.clipsToBounds = true
        imageview.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageview.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.ImageRightMargin),
            imageview.topAnchor.constraint(equalTo: navigationBar.topAnchor, constant: Const.ImageTopMargin),
            imageview.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            imageview.widthAnchor.constraint(equalTo: imageview.heightAnchor)
        ])
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Contacts..."
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = DesignTokens.LegacyColors.textBackground
        }
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    deinit {}
    
    private func observeAndHandleOrientationMode() {
        NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: OperationQueue.current) { [weak self] _ in
            
            if UIDevice.current.orientation.isPortrait {
                self?.title = Const.navTitle
                self?.moveAndResizeImageForPortrait()
                self?.shouldResize = true
            } else if UIDevice.current.orientation.isLandscape {
                self?.title = "Non 🙅🏽‍♂️ resizing image"
                self?.resizeImageForLandscape()
                self?.shouldResize = false
            }
        }
    }
    
    private func bind(to viewModel: ChatContactsViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.updateItems() }
        viewModel.loading.observe(on: self) { [weak self] in self?.updateLoading($0) }
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
    }
    
    @objc private func didTapBroadcastButton(_ sender: Any) {
        didSendEventClosure?(.chats)
    }
    
    private func updateViewsVisibility(model: ChatContactsViewModel) {
        loadingView.isHidden = true
        emptyDataLabel.isHidden = true
        suggestionsListContainer.isHidden = true
        
        //        updateQueriesSuggestionsVisibility()
    }
    
    private func updateQueriesSuggestionsVisibility() {
        if searchController.searchBar.isFirstResponder {
            viewModel.showQueriesSuggestions()
        } else {
            viewModel.closeQueriesSuggestions()
        }
    }
    
    private func updateItems() {
        chatContactsTableViewController?.reload()
    }
    
    private func updateLoading(_ loading: ChatContactsViewModelLoading?) {
        //        emptyDataLabel.isHidden = true
        //        suggestionsListContainer.isHidden = true
    }
    
    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: viewModel.errorTitle, message: error)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredContacts = viewModel.items.value.filter { (contact: ChatContactsListItemViewModel) -> Bool in
            return contact.contactName.lowercased().contains(searchText.lowercased())
        }
        
        chatContactsTableViewController?.tableView.reloadData()
    }
}


extension ChatContactListViewController: UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        //        chatContactsTableViewController?.tableView.setContentOffset(CGPoint.zero, animated: false)
        //        viewModel.didSearch(query: searchText)
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didCancelSearch()
    }
}

extension ChatContactListViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    public func willPresentSearchController(_ searchController: UISearchController) {
        showImage(isShow: false, duration: 0.25)
        
        navigationController?.navigationBar.setNeedsLayout()
        navigationController?.navigationBar.layoutIfNeeded()
        
        if let scrollView = chatContactsTableViewController?.tableView {
            scrollView.setContentOffset(CGPoint(x: 0, y: -scrollView.contentInset.top), animated: false)
        }
    }
    
    public func willDismissSearchController(_ searchController: UISearchController) {
        showImage(isShow: true, duration: 0.25)
    }
    
    public func didDismissSearchController(_ searchController: UISearchController) {
        showImage(isShow: true, duration: 0.25)
        
        navigationController?.navigationBar.setNeedsLayout()
        navigationController?.navigationBar.layoutIfNeeded()
        
        if let scrollView = chatContactsTableViewController?.tableView {
            scrollView.setContentOffset(CGPoint(x: 0, y: -scrollView.contentInset.top), animated: false)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.moveAndResizeImageForPortrait()
        }
    }
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}


// MARK: - Setup Search Controller

//extension ChatContactsListVC {
//    private func setupSearchController() {
//    }
//}


extension ChatContactListViewController {
    enum Event {
        case chats
    }
}

extension ChatContactListViewController {
    internal func moveAndResizeImageForPortrait() {
        if let searchController = navigationItem.searchController, searchController.isActive {
            return
        }

        guard let navBarHeight = navigationController?.navigationBar.frame.height else { return }
        
        let maxHeight = maxConsideredNavHeight
        let minHeight = Const.NavBarHeightSmallState
        
        let coeff: CGFloat = {
            let delta = navBarHeight - minHeight
            let heightDifference = maxHeight - minHeight
            return max(0, min(1, delta / heightDifference))
        }()
        
        let factor = Const.ImageSizeForSmallState / Const.ImageSizeForLargeState
        
        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()
        
        let sizeDiff = Const.ImageSizeForLargeState * (1.0 - factor)
        
        let yTranslation: CGFloat = {
            let maxYTranslation = Const.ImageBottomMarginForLargeState - Const.ImageBottomMarginForSmallState + sizeDiff
            return -maxYTranslation * (1 - coeff)
        }()
        
        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)
        
        imageview.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }
    
    
    internal func resizeImageForLandscape() {
        let yTranslation = Const.ImageSizeForLargeState * Const.ScaleForImageSizeForLandscape
        imageview.transform = CGAffineTransform.identity
            .scaledBy(x: Const.ScaleForImageSizeForLandscape, y: Const.ScaleForImageSizeForLandscape)
            .translatedBy(x: 0, y: yTranslation)
    }
    
    /// Show or hide the image from NavBar while going to next screen or back to initial screen
    ///
    /// - Parameter show: show or hide the image from NavBar
    internal func showImage(isShow: Bool, duration: Double) {
        UIView.animate(withDuration: duration) {
            self.imageview.alpha = isShow ? 1.0 : 0.0
        }
    }
}
