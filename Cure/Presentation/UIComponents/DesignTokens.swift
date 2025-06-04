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
        static let primaryCURE = Color("PrimaryCURE")
        static let secondaryCURE = Color("SecondaryCURE")
        
        static let companyChip = Color("CompanyChip")
        
        static let textForeground = Color("TextfieldFG")
        static let textBackground = Color("TextfieldBG")
        
        static let background = Color("BackgroundCURE")
        static let foreground = Color("ForegroundCURE")
        
        static let textClickable = Color(.systemBlue)
    }
    
    struct LegacyColors {
        static let primary = UIColor.primaryCURE
        static let secondary = UIColor.secondaryCURE
        
        static let textForeground = UIColor.textfieldFG
        static let textBackground = UIColor.textfieldBG
        
        static let textClickable = UIColor.systemBlue
        static let textDisabled = UIColor.lightGray
        
        static let lightBackground = UIColor.white
        static let darkBackground = UIColor.black
        
        static let bottomBar = UIColor.bottomBar
        static let companyChipBG = UIColor.companyChip
        static let activeFilterChipBG = UIColor.primaryCURE.withAlphaComponent(0.7)
    }
    
    @available(iOS 13.0, *)
    struct Typography {
        static let titleFont = Font.system(size: 24, weight: .bold)
        static let bodyFont = Font.system(size: 16, weight: .regular)
        static let body2Font = Font.system(size: 12, weight: .regular)
        static let subscriptFont = Font.system(size: 10, weight: .regular)
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
