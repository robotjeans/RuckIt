//
//  Color+Theme.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/11/25.
//
import SwiftUI

extension Color {
    // MARK: - RuckIt Brand Colors (namespaced to avoid collisions)
    
    /// Main background color and primary text - rgb(7, 9, 16)
    static let ruckitBackgroundPrimary = AppTheme.Colors.background
    
    /// Buttons, icons, links - rgb(223, 254, 174)
    static let ruckitAccentPrimary = AppTheme.Colors.primaryAccent
    
    /// Map route, position, health icons - rgb(192, 74, 144)
    static let ruckitAccentSecondary = AppTheme.Colors.secondaryAccent
    
    /// Card backgrounds, search fields - rgb(46, 47, 49)
    static let ruckitBackgroundSecondary = AppTheme.Colors.cardBackground
    
    /// Inactive icons and others - rgb(255, 255, 255)
    static let ruckitTextInactive = AppTheme.Colors.text
    
    // MARK: - Semantic Colors (for clarity in code)
    
    static let ruckitAppBackground = ruckitBackgroundPrimary
    static let ruckitCardBackground = ruckitBackgroundSecondary
    static let ruckitPrimaryButton = ruckitAccentPrimary
    static let ruckitPrimaryText = ruckitBackgroundPrimary
    static let ruckitSecondaryText = ruckitBackgroundSecondary
    static let ruckitRouteColor = ruckitAccentSecondary
    static let ruckitHealthColor = ruckitAccentSecondary
    static let ruckitInactiveIcon = ruckitTextInactive
}
