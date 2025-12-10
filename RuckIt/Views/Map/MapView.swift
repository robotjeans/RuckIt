//
//  MapView.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/10/25.
//
import SwiftUI
import MapKit

struct MapView: View {
    let locationPoints: [LocationPoint]
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        Map(coordinateRegion: $region,
            interactionModes: [.zoom, .pan],
            showsUserLocation: true,
            annotationItems: [lastPoint].compactMap { $0 }) { point in
            MapMarker(coordinate: point.coordinate, tint: .red)
        }
        .onAppear {
            updateRegion()
        }
        .onChange(of: locationPoints) {
            updateRegion()
        }
    }
    
    private var lastPoint: LocationPoint? {
        locationPoints.last
    }
    
    private func updateRegion() {
        guard !locationPoints.isEmpty else { return }
        let coordinates = locationPoints.map(\.coordinate)
        let overlay = MKPolyline(coordinates: coordinates, count: coordinates.count)
        let rect = overlay.boundingMapRect
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: rect.midY,
                longitude: rect.midX
            ),
            span: MKCoordinateSpan(
                latitudeDelta: rect.height > 0 ? rect.height : 0.01,
                longitudeDelta: rect.width > 0 ? rect.width : 0.01
            )
        )
    }
}
