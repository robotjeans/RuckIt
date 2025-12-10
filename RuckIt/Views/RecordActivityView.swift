//
//  RecordActivityView.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/10/25.
//
import SwiftUI
import MapKit
import CoreLocation

struct RecordActivityView: View {
    @Environment(ActivityManager.self) private var activityManager
    @Environment(LocationManager.self) private var locationManager
    @Environment(ActivityViewModel.self) private var activityViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?

    private var currentActivity: Activity? {
        activityManager.currentActivity
    }

    var body: some View {
        VStack {
            // Live Metrics
            VStack(spacing: 12) {
                HStack {
                    StatCard(title: "Time", value: formattedDuration(elapsedTime))
                    StatCard(title: "Distance", value: distanceString)
                }
                HStack {
                    StatCard(title: "Pace", value: paceString)
                    StatCard(title: "Elev", value: elevationString)
                }
            }
            .padding(.horizontal)

            // Map Preview
            MapView(locationPoints: currentActivity?.locationPoints ?? [])
                .frame(height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()

            // Control Buttons
            HStack(spacing: 20) {
                Button(role: .destructive) {
                    stopTimer()
                    activityManager.cancelRecording()
                    locationManager.stopUpdatingLocation()
                    dismiss()
                } label: {
                    Text("Cancel")
                        .fontWeight(.semibold)
                        .foregroundStyle(.red)
                }

                Spacer()

                Button {
                    if activityManager.isPaused {
                        activityManager.resumeRecording()
                        startTimer()
                    } else {
                        activityManager.pauseRecording()
                        stopTimer()
                    }
                } label: {
                    Image(systemName: activityManager.isPaused ? "play.fill" : "pause.fill")
                        .font(.title2)
                        .frame(width: 60, height: 60)
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .clipShape(Circle())
                }

                Spacer()

                Button {
                    Task {
                        stopTimer()
                        await activityManager.stopRecording()
                        locationManager.stopUpdatingLocation()
                        
                        // Save to ActivityViewModel
                        if let activity = activityManager.activities.last {
                            activityViewModel.add(activity)
                        }
                        
                        dismiss()
                    }
                } label: {
                    Text("Stop")
                        .fontWeight(.bold)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.red)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .navigationTitle("Recording...")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            locationManager.startUpdatingLocation()
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }

    // MARK: - Timer
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if let start = currentActivity?.startTime, !activityManager.isPaused {
                elapsedTime = Date().timeIntervalSince(start)
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Formatters

    private func formattedDuration(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60
        let seconds = Int(timeInterval) % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%d:%02d", minutes, seconds)
        }
    }

    private var distanceString: String {
        guard let distance = currentActivity?.distance else { return "0.00 km" }
        return String(format: "%.2f km", distance / 1000)
    }

    private var paceString: String {
        guard
            let activity = currentActivity,
            activity.distance > 100, // Only show pace after 100m
            elapsedTime > 0
        else { return "--'--\"" }

        let paceSecPerKm = elapsedTime / (activity.distance / 1000)
        let min = Int(paceSecPerKm) / 60
        let sec = Int(paceSecPerKm) % 60
        return String(format: "%d'%02d\"", min, sec)
    }

    private var elevationString: String {
        guard let gain = currentActivity?.elevationGain else { return "0 m" }
        return "\(Int(gain)) m"
    }
}
