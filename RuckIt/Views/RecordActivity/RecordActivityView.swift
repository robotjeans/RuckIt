//
//  RecordActivityView.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/10/25.
//
import SwiftUI
import MapKit

struct RecordActivityView: View {
    @Environment(ActivityManager.self) var activityManager
    @Environment(LocationManager.self) var locationManager
    @Environment(\.dismiss) var dismiss
    
    var currentActivity: Activity? {
        guard activityManager.isRecording else { return nil }
        return activityManager.currentActivity
    }
    
    var body: some View {
        VStack {
            // Live Metrics
            VStack(spacing: 12) {
                HStack {
                    StatCard(title: "Time", value: currentActivity?.duration.formatted(.units()) ?? "0s")
                    StatCard(title: "Distance", value: String(format: "%.2f km", (currentActivity?.distance ?? 0) / 1000))
                }
                HStack {
                    StatCard(title: "Pace", value: paceString)
                    StatCard(title: "Elev", value: "\(Int(currentActivity?.elevationGain ?? 0)) m")
                }
            }
            .padding(.horizontal)
            
            // Map
            MapView(locationPoints: currentActivity?.locationPoints ?? [])
                .frame(height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()
            
            // Controls
            HStack {
                Button(role: .destructive) {
                    activityManager.cancelRecording()
                    dismiss()
                } label: {
                    Text("Cancel")
                }
                
                Spacer()
                
                if activityManager.isPaused {
                    Button("Resume") {
                        activityManager.resumeRecording()
                    }
                } else {
                    Button("Pause") {
                        activityManager.pauseRecording()
                    }
                }
                
                Spacer()
                
                Button {
                    Task {
                        await activityManager.stopRecording()
                        dismiss()
                    }
                } label: {
                    Text("Stop")
                        .fontWeight(.bold)
                }
            }
            .padding()
        }
        .navigationTitle("Recording...")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var paceString: String {
        guard let activity = currentActivity,
              activity.distance > 0,
              activity.duration > 0 else { return "--" }
        let paceSecPerKm = activity.duration / (activity.distance / 1000)
        let min = Int(paceSecPerKm) / 60
        let sec = Int(paceSecPerKm) % 60
        return String(format: "%d:%02d/km", min, sec)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title3)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
