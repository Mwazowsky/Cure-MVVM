//
//  ChattingVC.swift
//  Cure
//
//  Created by MacBook Air MII  on 3/6/25.
//

import UIKit

protocol ChattingViewControllerDelegate: AnyObject {
    func moveAndResizeImageForPortrait()
    func resizeImageForLandscape()
    func showImage(_ show: Bool)
}

extension ChattingViewController {
    /// WARNING: Change these constants according to your project's design
    private struct Const {
        static let navTitle: String = "Abdul Dudu"
        /// Image height/width for Large NavBar state
        static let ImageSizeForLargeState: CGFloat = 60
        /// Margin from right anchor of safe area to right anchor of Image
        static let ImageRightMargin: CGFloat = 16
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
        static let ImageBottomMarginForLargeState: CGFloat = 12
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
        static let ImageBottomMarginForSmallState: CGFloat = 6
        /// Image height/width for Small NavBar state
        static let ImageSizeForSmallState: CGFloat = 50
        /// Height of NavBar for Small state. Usually it's just 44
        static let NavBarHeightSmallState: CGFloat = 60
        /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
        static let NavBarHeightLargeState: CGFloat = 96.5
        /// Image height/width for Landscape state
        static let ScaleForImageSizeForLandscape: CGFloat = 0.65
    }
}

final class ChattingViewController: UIViewController {
    private let imageview: UIImageView = UIImageView(image: UIImage(named: "profile-placeholder"))
    private var shouldResize: Bool = true
    
    private var chatingTableViewController: ChattingTableViewController?
    
    private var viewModel: ChatContactsViewModel!
    
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
    
    let parentView: UIView = UIView()
    
    static func create(
        with viewModel: ChatContactsViewModel
    ) -> ChattingViewController {
        let view = ChattingViewController()
        
        view.viewModel = viewModel
        
        return view
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        observeAndHandleOrientationMode()
        
        if UIDevice.current.orientation.isPortrait {
            shouldResize = true
        } else if UIDevice.current.orientation.isLandscape {
            shouldResize = false
        }
        
        bind(to: viewModel)
        
        self.chatingTableViewController = ChattingTableViewController()
        chatingTableViewController?.viewModel = viewModel
        
        viewModel.viewDidLoad()
        
        guard let chattingTVController = chatingTableViewController else { return }
        
        parentView.backgroundColor = DesignTokens.LegacyColors.primary
        parentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(parentView)

        NSLayoutConstraint.activate([
            parentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            parentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            parentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            parentView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        parentView.addSubview(chattingTVController.view)

        NSLayoutConstraint.activate([
            chattingTVController.view.topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor),
            chattingTVController.view.bottomAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.bottomAnchor),
            chattingTVController.view.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            chattingTVController.view.trailingAnchor.constraint(equalTo: parentView.trailingAnchor)
        ])
        
        chatingTableViewController?.didMove(toParent: self)
        self.chatingTableViewController = chattingTVController
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showImage(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showImage(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        if shouldResize {
            moveAndResizeImageForPortrait()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        hidesBottomBarWhenPushed = true
    }
    
    // MARK: - Private methods
    private func setupUI() {
        title = Const.navTitle
        
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(imageview)
        imageview.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        imageview.clipsToBounds = true
        imageview.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageview.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.ImageRightMargin),
            imageview.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            imageview.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            imageview.widthAnchor.constraint(equalTo: imageview.heightAnchor)
        ])
    }
    
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
}

extension ChattingViewController: Alertable {
    private func updateItems() {
        chatingTableViewController?.reload()
    }
    
    private func updateLoading(_ loading: ChatContactsViewModelLoading?) {
        emptyDataLabel.isHidden = true
        suggestionsListContainer.isHidden = true
    }
    
    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: viewModel.errorTitle, message: error)
    }
}

extension ChattingViewController: ChattingViewControllerDelegate {
    internal func moveAndResizeImageForPortrait() {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        
        let coeff: CGFloat = {
            let delta = height - Const.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()
        
        let factor = Const.ImageSizeForSmallState / Const.ImageSizeForLargeState
        
        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()
        
        // Value of difference between icons for large and small states
        let sizeDiff = Const.ImageSizeForLargeState * (1.0 - factor) // 8.0
        
        let yTranslation: CGFloat = {
            /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
            let maxYTranslation = Const.ImageBottomMarginForLargeState - Const.ImageBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Const.ImageBottomMarginForSmallState + sizeDiff))))
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
    internal func showImage(_ show: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.imageview.alpha = show ? 1.0 : 0.0
        }
    }
}
