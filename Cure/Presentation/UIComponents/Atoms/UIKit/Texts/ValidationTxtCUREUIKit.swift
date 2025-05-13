//
//  ZTHLabel.swift
//  UIkitZeroToHero
//
//  Created by Saifulloh Fadli on 05/02/25.
//

import UIKit

enum TextFieldValidationStatus {
    case valid
    case invalid([String])
    case required
    case empty
}


class ValidationTxtCUREUIKit: UILabel {
    // MARK: INITIALIZATION
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: CONFIGURAtION
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        font            = UIFont.systemFont(ofSize: 12, weight: .medium)
        numberOfLines   = 0
        textAlignment   = .left
        alpha           = 0
    }
    
    
    // MARK: VALIDATION HANDLING
    func setValidationStatus(_ status: TextFieldValidationStatus) {
        switch status {
        case .valid:
            showValidState()
        case .invalid(let messages):
            showInvalidState(messages: messages)
        case .required:
            showRequiredState()
        case .empty:
            showEmptyState()
        }
    }
    
    
    private func showValidState() {
        text = "✓ Valid"
        textColor = .systemGreen
        animateVisibility(visible: true)
    }
    
    
    private func showInvalidState(messages: [String]) {
        text = messages.joined(separator: "\n")
        textColor = .systemRed
        animateVisibility(visible: true)
    }
    
    
    private func showRequiredState() {
        text = "⚠️ This field is required"
        textColor = .systemOrange
        animateVisibility(visible: true)
    }
    
    
    private func showEmptyState() {
        text = "Please enter a value"
        textColor = .systemGray
        animateVisibility(visible: true)
    }
    
    
    private func animateVisibility(visible: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.alpha = visible ? 1 : 0
        }
    }
}
