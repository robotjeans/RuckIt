//
//  ActivityManager.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/10/25.
//
import Foundation
import CoreLocation
import Observation

@Observable
final class ActivityManager {
    static let shared = ActivityManager()

    var isRecording = false
    var isPaused = false
    var currentActivity: Activity?
    var activities: [Activity] = []

    private var lastLocation: CLLocation?
    private var accumulatedDistance: Double = 0
    private var lastAltitude: Double?
    private var accumulatedElevationGain: Double = 0

    private init() {}

    func startNewActivity(name: String, type: ActivityType, ruckWeight: Double = 0) {
        guard !isRecording else { return }
        currentActivity = Activity(
            id: UUID(),
            name: name,
            startTime: Date(),
            endTime: nil,
            distance: 0,
            elevationGain: 0,
            locationPoints: [],
            type: type,
            ruckWeight: ruckWeight > 0 ? ruckWeight : nil,
            caloriesBurned: nil
        )
        resetTrackingState()
        isRecording = true
        isPaused = false
    }

    func pauseRecording() { isPaused = true }
    func resumeRecording() { isPaused = false }

    func stopRecording() async {
        guard isRecording, let activity = currentActivity else { return }
        
        // Calculate calories burned
        let calories = calculateCalories(
            distance: accumulatedDistance,
            duration: Date().timeIntervalSince(activity.startTime),
            ruckWeight: activity.ruckWeight ?? 0
        )
        
        let finalized = Activity(
            id: activity.id,
            name: activity.name,
            startTime: activity.startTime,
            endTime: Date(),
            distance: accumulatedDistance,
            elevationGain: accumulatedElevationGain,
            locationPoints: activity.locationPoints,
            type: activity.type,
            ruckWeight: activity.ruckWeight,
            caloriesBurned: calories
        )
        activities.append(finalized)
        cleanup()
    }
    
    private func calculateCalories(distance: Double, duration: TimeInterval, ruckWeight: Double) -> Double {
        guard let userWeight = UserProfile.shared.weight else { return 0 }
        
        // MET (Metabolic Equivalent) values
        let baseWalkingMET: Double = 3.5 // Walking at moderate pace
        let ruckingMultiplier: Double = 1.3 // Increase for carrying weight
        
        // Additional MET for carried weight (roughly 0.2 MET per 5kg)
        let weightMET = (ruckWeight / 5.0) * 0.2
        
        let totalMET = baseWalkingMET * ruckingMultiplier + weightMET
        
        // Calories = MET × weight (kg) × duration (hours)
        let durationHours = duration / 3600
        let calories = totalMET * userWeight * durationHours
        
        return calories
    }

    func cancelRecording() {
        cleanup()
    }

    func addLocation(_ location: CLLocation) {
        guard isRecording, !isPaused else { return }

        let point = LocationPoint(
            timestamp: location.timestamp,
            coordinate: location.coordinate,
            altitude: location.altitude
        )
        currentActivity?.locationPoints.append(point)

        // Calculate distance
        if let last = lastLocation {
            accumulatedDistance += location.distance(from: last)
        }
        lastLocation = location

        // Calculate elevation gain
        if let lastAlt = lastAltitude {
            let delta = location.altitude - lastAlt
            if delta > 0 {
                accumulatedElevationGain += delta
            }
        }
        lastAltitude = location.altitude
    }

    private func resetTrackingState() {
        lastLocation = nil
        accumulatedDistance = 0
        lastAltitude = nil
        accumulatedElevationGain = 0
    }

    private func cleanup() {
        currentActivity = nil
        isRecording = false
        isPaused = false
        resetTrackingState()
    }
}
