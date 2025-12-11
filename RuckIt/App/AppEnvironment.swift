//
//  AppEnvironment.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/11/25.
//
import Foundation
import Observation

@Observable
final class AppEnvironment {
    // Core managers (singletons)
    let activityManager: ActivityManager
    let locationManager: LocationManager
    let userProfile: UserProfile
    
    // View models
    let activityViewModel: ActivityViewModel
    
    static let shared = AppEnvironment()
    
    private init() {
        // Initialize managers
        self.activityManager = ActivityManager.shared
        self.locationManager = LocationManager.shared
        self.userProfile = UserProfile.shared
        
        // Initialize view models
        self.activityViewModel = ActivityViewModel()
        
        // Load persisted data
        activityViewModel.load()
    }
}
