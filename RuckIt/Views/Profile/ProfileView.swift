//
//  ProfileView.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/11/25.
//
import SwiftUI

struct ProfileView: View {
    @Environment(UserProfile.self) private var userProfile
    @Environment(ActivityViewModel.self) private var activityViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile Header with Settings button
                HStack {
                    Spacer()
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal)
                
                // Avatar
                ZStack {
                    Circle()
                        .fill(Color.blue.gradient)
                        .frame(width: 100, height: 100)
                    
                    Text(initials)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(.white)
                }
                
                // Profile Stats
                VStack(spacing: 8) {
                    if let age = userProfile.age {
                        Text("\(age) years old")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    if let gender = userProfile.gender {
                        Text(gender.rawValue)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                // Quick Stats Cards
                HStack(spacing: 16) {
                    if let weight = userProfile.weight {
                        StatCard(
                            title: "Weight",
                            value: String(format: "%.1f kg", weight),
                            icon: "scalemass"
                        )
                    }
                    
                    if let height = userProfile.height {
                        StatCard(
                            title: "Height",
                            value: String(format: "%.0f cm", height),
                            icon: "ruler"
                        )
                    }
                }
                .padding(.horizontal)
                
                // Activity Summary
                VStack(alignment: .leading, spacing: 16) {
                    Text("Activity Summary")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        SummaryRow(
                            title: "Total Activities",
                            value: "\(activityViewModel.activities.count)",
                            icon: "figure.walk"
                        )
                        
                        SummaryRow(
                            title: "Total Distance",
                            value: String(format: "%.2f km", totalDistance),
                            icon: "map"
                        )
                        
                        SummaryRow(
                            title: "Total Duration",
                            value: formattedTotalDuration,
                            icon: "clock"
                        )
                        
                        if totalCalories > 0 {
                            SummaryRow(
                                title: "Calories Burned",
                                value: String(format: "%.0f kcal", totalCalories),
                                icon: "flame"
                            )
                        }
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                }
                
                // Complete Profile Button (if incomplete)
                if !userProfile.isProfileComplete {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.orange)
                            Text("Complete Your Profile")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Computed Properties
    
    private var initials: String {
        // You could add a name field to UserProfile
        // For now, just show a generic icon
        "U"
    }
    
    private var totalDistance: Double {
        activityViewModel.activities.reduce(0) { $0 + $1.distance } / 1000
    }
    
    private var totalDuration: TimeInterval {
        activityViewModel.activities.reduce(0) { $0 + $1.duration }
    }
    
    private var formattedTotalDuration: String {
        let hours = Int(totalDuration) / 3600
        let minutes = Int(totalDuration) / 60 % 60
        return "\(hours)h \(minutes)m"
    }
    
    private var totalCalories: Double {
        activityViewModel.activities.compactMap { $0.caloriesBurned }.reduce(0, +)
    }
}

#Preview {
    NavigationStack {
        ProfileView()
            .environment(UserProfile.shared)
            .environment(ActivityViewModel())
    }
}
