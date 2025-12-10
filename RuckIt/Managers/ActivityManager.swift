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

    // SwiftUI observes changes to these automatically
    var isRecording = false
    var isPaused = false
    var currentActivity: Activity?
    var activities: [Activity] = []

    // Tracking state (not observed by UI, so private)
    private var lastLocation: CLLocation?
    private var accumulatedDistance: Double = 0
    private var lastAltitude: Double = 0
    private var accumulatedElevationGain: Double = 0

    private init() {}

    // --- Public API ---
    func startNewActivity(name: String, type: ActivityType) {
        guard !isRecording else { return }
        currentActivity = Activity(
            id: UUID(),
            name: name,
            startTime: Date(),
            endTime: nil,
            distance: 0,
            elevationGain: 0,
            locationPoints: [],
            type: type
        )
        resetTrackingState()
        isRecording = true
        isPaused = false
    }

    func pauseRecording() { isPaused = true }
    func resumeRecording() { isPaused = false }

    func stopRecording() async {
        guard isRecording, let activity = currentActivity else { return }
        let finalized = Activity(
            id: activity.id,
            name: activity.name,
            startTime: activity.startTime,
            endTime: Date(),
            distance: accumulatedDistance,
            elevationGain: accumulatedElevationGain,
            locationPoints: activity.locationPoints,
            type: activity.type
        )
        activities.append(finalized)
        cleanup()
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

        if let last = lastLocation {
            accumulatedDistance += location.distance(from: last)
        }
        lastLocation = location

        if lastLocation != nil {
            let delta = location.altitude - lastAltitude
            if delta > 0 { accumulatedElevationGain += delta }
        }
        lastAltitude = location.altitude
    }

    // --- Private ---
    private func resetTrackingState() {
        lastLocation = nil
        accumulatedDistance = 0
        lastAltitude = 0
        accumulatedElevationGain = 0
    }

    private func cleanup() {
        currentActivity = nil
        isRecording = false
        isPaused = false
        resetTrackingState()
    }
}
