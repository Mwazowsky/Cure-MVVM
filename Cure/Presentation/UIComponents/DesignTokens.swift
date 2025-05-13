//
//  DesignTokens.swift
//  Cure
//
//  Created by MacBook Air MII  on 8/5/25.
//

import UIKit
import SwiftUICore

struct DesignTokens {
    @available(iOS 13.0, *)
    struct Colors {
        static let primary = Color("PrimaryRed")
        static let secondary = Color("SecondaryColor")
        static let background = Color("BackgroundColor")
    }
    
    struct LegacyColors {
        static let primary = UIColor.primaryRed
        static let dark = UIColor.black
        
        static let textFieldForeground = UIColor.textfieldFG
        static let textFieldBackground = UIColor.textfieldBG
        
        static let lightBackground = UIColor.white
        static let darkBackground = UIColor.black
    }
    
    @available(iOS 13.0, *)
    struct Typography {
        static let titleFont = Font.system(size: 24, weight: .bold)
        static let bodyFont = Font.system(size: 16, weight: .regular)
    }
    
    struct LegacyTypography {
        static let titleFont = UIFont.systemFont(ofSize: 24, weight: .bold)
        static let bodyFont = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    
    struct Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
    }
}
