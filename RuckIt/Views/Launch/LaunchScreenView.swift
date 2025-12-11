//
//  LaunchScreenView.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/11/25.
//
import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        ZStack {
            AppTheme.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Icon/Logo
                Image(systemName: "figure.walk")
                    .font(.system(size: 80))
                    .foregroundStyle(AppTheme.Colors.primaryAccent)
                
                // App Name
                Text("RuckIt!")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.Colors.primaryAccent)
                
                // Optional Tagline
                Text("Track Your Journey")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.Colors.text.opacity(0.7))
            }
        }
    }
}

#Preview {
    LaunchScreenView()
}
