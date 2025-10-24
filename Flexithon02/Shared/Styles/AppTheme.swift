//
//  AppTheme.swift
//  Flexithon02
//
//  Shared theme constants for consistent UI design
//

import SwiftUI

struct AppTheme {
    
    // MARK: - Colors
    struct Colors {
        // Primary colors
        static let primary = Color(red: 0.4, green: 0.49, blue: 0.92)
        static let secondary = Color(red: 0.46, green: 0.29, blue: 0.64)
        
        // Background colors
        static let background = LinearGradient(
            colors: [Color(red: 0.4, green: 0.49, blue: 0.92), Color(red: 0.46, green: 0.29, blue: 0.64)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // Text colors
        static let textPrimary = Color.white
        static let textSecondary = Color.white.opacity(0.9)
        static let textTertiary = Color.white.opacity(0.7)
        
        // Card colors
        static let cardBackground = Color.white.opacity(0.15)
        static let cardBackgroundSecondary = Color.white.opacity(0.2)
        
        // Button colors
        static let buttonPrimary = Color.white
        static let buttonSecondary = Color.white.opacity(0.2)
        static let buttonTertiary = Color.white.opacity(0.3)
        
        // Status colors
        static let error = Color.red
        static let errorBackground = Color.red.opacity(0.2)
        static let success = Color.green
        static let warning = Color.orange
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let extraSmall: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let extraLarge: CGFloat = 32
        static let huge: CGFloat = 40
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 20
        static let extraLarge: CGFloat = 24
    }
    
    // MARK: - Font Sizes
    struct FontSize {
        static let caption: CGFloat = 12
        static let body: CGFloat = 16
        static let headline: CGFloat = 18
        static let title: CGFloat = 24
        static let largeTitle: CGFloat = 64
        static let icon: CGFloat = 80
    }
    
    // MARK: - Shadows
    struct Shadow {
        static let card = Color.black.opacity(0.2)
        static let cardRadius: CGFloat = 20
        static let cardOffset = CGSize(width: 0, height: 10)
    }
    
    // MARK: - Animation
    struct Animation {
        static let quick = SwiftUI.Animation.easeInOut(duration: 0.2)
        static let medium = SwiftUI.Animation.easeInOut(duration: 0.3)
        static let slow = SwiftUI.Animation.easeInOut(duration: 0.5)
    }
}

// MARK: - View Extensions for Easy Access
extension View {
    func appCardStyle() -> some View {
        self
            .padding(AppTheme.Spacing.large)
            .background(AppTheme.Colors.cardBackground)
            .cornerRadius(AppTheme.CornerRadius.large)
            .shadow(color: AppTheme.Shadow.card, radius: AppTheme.Shadow.cardRadius, x: AppTheme.Shadow.cardOffset.width, y: AppTheme.Shadow.cardOffset.height)
    }
    
    func appButtonStyle(style: AppButtonStyle = .primary) -> some View {
        self
            .padding(AppTheme.Spacing.medium)
            .frame(maxWidth: .infinity)
            .background(style.backgroundColor)
            .foregroundColor(style.foregroundColor)
            .cornerRadius(AppTheme.CornerRadius.medium)
    }
}

// MARK: - Button Styles
enum AppButtonStyle {
    case primary
    case secondary
    case tertiary
    
    var backgroundColor: Color {
        switch self {
        case .primary:
            return AppTheme.Colors.buttonPrimary
        case .secondary:
            return AppTheme.Colors.buttonSecondary
        case .tertiary:
            return AppTheme.Colors.buttonTertiary
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .primary:
            return AppTheme.Colors.primary
        case .secondary, .tertiary:
            return AppTheme.Colors.textPrimary
        }
    }
}
