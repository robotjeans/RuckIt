//
//  LocationPoint.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/10/25.
//
import Foundation
import CoreLocation

struct LocationPoint: Codable, Equatable, Hashable, Identifiable {
    let id: UUID
    let timestamp: Date
    let coordinate: Coordinate
    let altitude: Double

    init(timestamp: Date, coordinate: CLLocationCoordinate2D, altitude: Double) {
        self.id = UUID()
        self.timestamp = timestamp
        self.coordinate = Coordinate(from: coordinate)
        self.altitude = altitude
    }
}
