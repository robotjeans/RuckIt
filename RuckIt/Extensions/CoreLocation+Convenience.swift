//
//  CoreLocation+Convenience.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/10/25.
//
import CoreLocation

// Make CLLocationCoordinate2D work with SwiftUI navigation & collections
extension CLLocationCoordinate2D: Equatable, Hashable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}
