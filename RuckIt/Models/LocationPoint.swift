//
//  LocationPoint.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/10/25.
//
import Foundation
import CoreLocation

struct LocationPoint: Codable, Equatable, Hashable {
    let timestamp: Date
    let coordinate: CLLocationCoordinate2D
    let altitude: Double

    // 👇 ADD THIS INITIALIZER
    init(timestamp: Date, coordinate: CLLocationCoordinate2D, altitude: Double) {
        self.timestamp = timestamp
        self.coordinate = coordinate
        self.altitude = altitude
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case timestamp, latitude, longitude, altitude
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.timestamp = try container.decode(Date.self, forKey: .timestamp)
        self.altitude = try container.decode(Double.self, forKey: .altitude)
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(altitude, forKey: .altitude)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }
}
