//
//  PrimaryBtnCURE.swift
//  Cure
//
//  Created by MacBook Air MII  on 9/5/25.
//

import UIKit

class TextBtnCUREUIKit: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        
        self.backgroundColor = .clear
        self.setTitle(title, for: .normal)
        
        self.configure()
    }
    
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
        
        setTitleColor(DesignTokens.LegacyColors.textClickable, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
    }
    
    
}
