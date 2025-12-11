//
//  ActivityDetailView.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/10/25.
//
import SwiftUI
import CoreLocation

struct ActivityDetailView: View {
    let activity: Activity
    @Environment(\.dismiss) private var dismiss
    @Environment(ActivityViewModel.self) private var activityViewModel
    
    @State private var showDeleteConfirmation = false

    private func formattedDuration(_ timeInterval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: timeInterval) ?? "0s"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Activity Header
                VStack(spacing: 8) {
                    Text(activity.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(activity.startTime.formatted(date: .long, time: .shortened))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    // Activity Type Badge
                    Text(activity.type.rawValue.capitalized)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.2))
                        .foregroundStyle(.blue)
                        .clipShape(Capsule())
                }
                .padding(.top)

                // Main Stats Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    DetailStatCard(
                        icon: "clock.fill",
                        title: "Duration",
                        value: formattedDuration(activity.duration)
                    )
                    
                    DetailStatCard(
                        icon: "figure.walk",
                        title: "Distance",
                        value: String(format: "%.2f km", activity.distance / 1000)
                    )
                    
                    DetailStatCard(
                        icon: "mountain.2.fill",
                        title: "Elevation",
                        value: "\(Int(activity.elevationGain)) m"
                    )
                    
                    DetailStatCard(
                        icon: "speedometer",
                        title: "Avg Pace",
                        value: averagePace
                    )
                    
                    if let ruckWeight = activity.ruckWeight, ruckWeight > 0 {
                        DetailStatCard(
                            icon: "backpack.fill",
                            title: "Ruck Weight",
                            value: String(format: "%.1f kg", ruckWeight)
                        )
                    }
                    
                    if let calories = activity.caloriesBurned, calories > 0 {
                        DetailStatCard(
                            icon: "flame.fill",
                            title: "Calories",
                            value: String(format: "%.0f kcal", calories)
                        )
                    }
                }
                .padding(.horizontal)

                // Map Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Route")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    if !activity.locationPoints.isEmpty {
                        MapView(locationPoints: activity.locationPoints)
                            .frame(height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal)
                    } else {
                        Text("No route data available")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    }
                }
                
                // Delete Button
                Button(role: .destructive) {
                    showDeleteConfirmation = true
                } label: {
                    Label("Delete Activity", systemImage: "trash")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .foregroundStyle(.red)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete Activity?", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteActivity()
            }
        } message: {
            Text("This action cannot be undone.")
        }
    }
    
    private var averagePace: String {
        guard activity.distance > 0, activity.duration > 0 else { return "--'--\"" }
        let paceSecPerKm = activity.duration / (activity.distance / 1000)
        let min = Int(paceSecPerKm) / 60
        let sec = Int(paceSecPerKm) % 60
        return String(format: "%d'%02d\"", min, sec)
    }
    
    private func deleteActivity() {
        if let index = activityViewModel.activities.firstIndex(where: { $0.id == activity.id }) {
            activityViewModel.delete(at: IndexSet(integer: index))
        }
        dismiss()
    }
}
