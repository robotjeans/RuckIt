//
//  Activity.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/10/25.
//
import Foundation
import CoreLocation

struct Activity: Identifiable, Codable, Equatable, Hashable {
    var id: UUID
    var name: String
    var startTime: Date
    var endTime: Date?
    var distance: Double
    var elevationGain: Double
    var locationPoints: [LocationPoint]
    var type: ActivityType
    var ruckWeight: Double? // kg
    var caloriesBurned: Double?

    var duration: TimeInterval {
        guard let endTime = endTime else { return 0 }
        return endTime.timeIntervalSince(startTime)
    }
}

