//
//  ActivityDetailView.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/10/25.
//
import SwiftUI

struct ActivityDetailView: View {
    let activity: Activity
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Summary
                VStack(spacing: 8) {
                    Text(activity.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(activity.startTime.formatted(date: .long, time: .shortened))
                        .foregroundColor(.secondary)
                }
                
                // Stats
                HStack {
                    StatRow(title: "Duration", value: Duration(activity.duration).formatted(.units()))
                    StatRow(title: "Distance", value: String(format: "%.2f km", activity.distance / 1000))
                }
                HStack {
                    StatRow(title: "Elevation", value: "\(Int(activity.elevationGain)) m")
                    StatRow(title: "Type", value: activity.type.rawValue.capitalized)
                }
                
                // Map Preview
                MapView(locationPoints: activity.locationPoints)
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
        .navigationTitle("Activity")
    }
}

