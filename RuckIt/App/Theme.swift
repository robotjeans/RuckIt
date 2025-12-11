//
//  Theme.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/11/25.
//
import SwiftUI

struct AppTheme {
    struct Colors {
        static let background = Color.backgroundPrimary
        static let cardBackground = Color.backgroundSecondary
        static let primaryAccent = Color.accentPrimary
        static let secondaryAccent = Color.accentSecondary
        static let text = Color.textInactive
        static let inactiveIcon = Color.textInactive.opacity(0.5)
    }
    
    struct Typography {
        static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
        static let title = Font.system(size: 28, weight: .bold, design: .rounded)
        static let headline = Font.system(size: 17, weight: .semibold, design: .rounded)
        static let body = Font.system(size: 17, weight: .regular, design: .default)
        static let caption = Font.system(size: 12, weight: .regular, design: .default)
    }
    
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
    }
    
    struct CornerRadius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
    }
}
