//
//  MapView.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/10/25.
//
import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    let locationPoints: [LocationPoint]
    
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    
    var body: some View {
        Map(position: $position, interactionModes: [.zoom, .pan]) {
            // Draw the route line
            if locationPoints.count > 1 {
                MapPolyline(coordinates: locationPoints.map { $0.coordinate.clLocationCoordinate2D })
                    .stroke(.blue, lineWidth: 3)
            }
            
            // Start marker
            if let firstPoint = locationPoints.first {
                Marker("Start", coordinate: firstPoint.coordinate.clLocationCoordinate2D)
                    .tint(.green)
            }
            
            // End marker
            if let lastPoint = locationPoints.last, locationPoints.count > 1 {
                Marker("End", coordinate: lastPoint.coordinate.clLocationCoordinate2D)
                    .tint(.red)
            }
        }
        .onAppear {
            updateRegion()
        }
        .onChange(of: locationPoints) {
            updateRegion()
        }
    }
    
    private func updateRegion() {
        guard !locationPoints.isEmpty else { return }
        let coordinates = locationPoints.map { $0.coordinate.clLocationCoordinate2D }
        
        let lats = coordinates.map { $0.latitude }
        let lons = coordinates.map { $0.longitude }
        
        guard let minLat = lats.min(), let maxLat = lats.max(),
              let minLon = lons.min(), let maxLon = lons.max() else { return }
        
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        
        let span = MKCoordinateSpan(
            latitudeDelta: max((maxLat - minLat) * 1.5, 0.01),
            longitudeDelta: max((maxLon - minLon) * 1.5, 0.01)
        )
        
        position = .region(MKCoordinateRegion(center: center, span: span))
    }
}
