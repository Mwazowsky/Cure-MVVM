//
//  DefaultTFCUREUIKit.swift
//  Cure
//
//  Created by MacBook Air MII  on 9/5/25.
//

import UIKit

class DefaultTFCUREUIKit: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = DesignTokens.LegacyColors.darkBackground.cgColor
        
        adjustsFontSizeToFitWidth = true
        
        textColor = DesignTokens.LegacyColors.primary
        
    }
    
}
