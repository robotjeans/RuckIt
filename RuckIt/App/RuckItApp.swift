//
//  RuckItApp.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/10/25.
//
import SwiftUI

@main
struct RuckItApp: App {
    @State private var activityManager = ActivityManager.shared
    @State private var locationManager = LocationManager.shared
    @State private var userProfile = UserProfile.shared
    @State private var activityViewModel = ActivityViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(activityManager)
                .environment(locationManager)
                .environment(userProfile)
                .environment(activityViewModel)
                .preferredColorScheme(.dark) // Force dark mode
                .tint(Color.accentPrimary) // Global accent color
                .onAppear {
                    activityViewModel.load()
                    setupAppearance()
                }
        }
    }
    
    private func setupAppearance() {
        // Tab Bar appearance
        UITabBar.appearance().backgroundColor = UIColor(AppTheme.Colors.cardBackground)
        UITabBar.appearance().unselectedItemTintColor = UIColor(AppTheme.Colors.text.opacity(0.5))
        
        // Navigation Bar appearance
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(AppTheme.Colors.background)
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(AppTheme.Colors.text)]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(AppTheme.Colors.text)]
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
    }
}
