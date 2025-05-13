//
//  DefaultTFCUREUIKit.swift
//  Cure
//
//  Created by MacBook Air MII  on 9/5/25.
//

import UIKit

class DefaultTFCUREUIKit: UITextField {
    
    init(title: String, isSecure: Bool) {
        super.init(frame: .zero)
        
        self.placeholder = title
        self.configure(isSecure: isSecure)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(isSecure: Bool) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 20))
        
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 8
        
        adjustsFontSizeToFitWidth = true
        
        textColor = DesignTokens.LegacyColors.textFieldForeground
        tintColor = DesignTokens.LegacyColors.textFieldForeground
        leftView = paddingView
        leftViewMode = .always
        font = DesignTokens.LegacyTypography.bodyFont
        minimumFontSize = 12
        
        backgroundColor = DesignTokens.LegacyColors.textFieldBackground
        autocorrectionType = .no
        
        textContentType = .password
        
        keyboardType = .default
        autocapitalizationType = .none
        autocorrectionType = .no
        
        returnKeyType = .go
        
        isSecureTextEntry = isSecure
    }
}
