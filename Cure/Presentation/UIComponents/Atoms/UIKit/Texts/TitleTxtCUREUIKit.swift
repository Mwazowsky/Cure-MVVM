
//
//  ZTHLabel.swift
//  UIkitZeroToHero
//
//  Created by Saifulloh Fadli on 05/02/25.
//

import UIKit

class TitleTxtCUREUIKit: UILabel {
    // MARK: INITIALIZATION
    init(textStyle: UIFont.TextStyle, title: String) {
        super.init(frame: .zero)
        self.text = title
        self.font = UIFont.preferredFont(forTextStyle: textStyle)
        self.adjustsFontForContentSizeCategory = true
        
        configure()
    }
    
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
        
        numberOfLines   = 0
        textAlignment   = .center
        alpha           = 1
    }
}
