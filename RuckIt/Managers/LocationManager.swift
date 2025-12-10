//
//  LocationManager.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/10/25.
//
import Foundation
import CoreLocation
import Observation
import UIKit

@Observable
final class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    
    // Authorization & availability state
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var isLocationAvailable: Bool {
        CLLocationManager.locationServicesEnabled()
    }
    
    // Computed property for easier checking
    var isAuthorized: Bool {
        authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
    }
    
    var isDenied: Bool {
        authorizationStatus == .denied || authorizationStatus == .restricted
    }
    
    // Latest location (for UI preview, map centering, etc.)
    var lastLocation: CLLocation?
    
    // Background task support
    private var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid
        
    private override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 3.0
        locationManager.activityType = .fitness
    }
        
    func requestAuthorization() {
        guard isLocationAvailable else { return }
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        guard isLocationAvailable else { return }
        
        // Check if already authorized
        if isAuthorized {
            startBackgroundTask()
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.showsBackgroundLocationIndicator = true
            locationManager.startUpdatingLocation()
        } else if authorizationStatus == .notDetermined {
            requestAuthorization()
        }
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = false
        endBackgroundTask()
    }
        
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("✅ Location authorized")
            if ActivityManager.shared.isRecording {
                startUpdatingLocation()
            }
            
        case .denied, .restricted:
            print("❌ Location access denied")
            
        case .notDetermined:
            print("⏳ Location authorization pending")
            
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let now = Date()
        let age = now.timeIntervalSince(location.timestamp)
        if age > 10.0 {
            print("⚠️ Discarding stale location (age: \(age)s)")
            return
        }
        
        if location.horizontalAccuracy < 0 || location.horizontalAccuracy > 65 {
            print("⚠️ Low accuracy location: \(location.horizontalAccuracy)m")
        }
        
        lastLocation = location
        
        if ActivityManager.shared.isRecording {
            ActivityManager.shared.addLocation(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("📍 LocationManager error: \(error.localizedDescription)")
    }
        
    private func startBackgroundTask() {
        endBackgroundTask()
        backgroundTaskID = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.stopUpdatingLocation()
        }
    }
    
    private func endBackgroundTask() {
        if backgroundTaskID != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTaskID)
            backgroundTaskID = .invalid
        }
    }
}
