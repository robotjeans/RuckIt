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
                // Summary
                VStack(spacing: 4) {
                    Text(activity.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(activity.startTime.formatted(date: .long, time: .shortened))
                        .foregroundStyle(.secondary)
                }

                // Stats
                HStack {
                    StatRow(title: "Duration", value: formattedDuration(activity.duration))
                    StatRow(title: "Distance", value: String(format: "%.2f km", activity.distance / 1000))
                }
                HStack {
                    StatRow(title: "Elevation", value: "\(Int(activity.elevationGain)) m")
                    StatRow(title: "Type", value: activity.type.rawValue.capitalized)
                }

                MapView(locationPoints: activity.locationPoints)
                    .frame(height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
        .navigationTitle("Activity")
    }
}
