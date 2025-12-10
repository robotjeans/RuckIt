//
//  RecordingViewModel.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/10/25.
//
import CoreLocation
import MapKit
import Combine

class RecordingViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var isPaused = false
    @Published var elapsedTime: String = "00:00"
    @Published var distanceString: String = "0.00 km"
    @Published var paceString: String = "--:--"
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    @Published var routeCoordinates: [CLLocationCoordinate2D] = []
}
