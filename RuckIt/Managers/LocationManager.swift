//
//  LocationManager.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/10/25.
//
import Foundation
import CoreLocation
import Observation

@Observable
final class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    
    // Authorization & availability state
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var isLocationAvailable: Bool {
        CLLocationManager.locationServicesEnabled()
    }
    
    // Latest location (for UI preview, map centering, etc.)
    var lastLocation: CLLocation? = nil
    
    // Background task support
    private var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid
    
    // MARK: - Initialization
    
    private override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 3.0 // meters – balances battery & accuracy
        locationManager.activityType = .fitness // Optimized for walking/running
        
        // Request authorization
        requestAuthorization()
    }
    
    // MARK: - Public API
    
    func requestAuthorization() {
        guard isLocationAvailable else { return }
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            // Optional: Request "Always" if you want background tracking
            // locationManager.requestAlwaysAuthorization()
            break
        default:
            break
        }
    }
    
    func startUpdatingLocation() {
        guard isLocationAvailable else { return }
        
        let status = locationManager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            // Start background task to prevent suspension
            startBackgroundTask()
            locationManager.startUpdatingLocation()
        } else {
            requestAuthorization()
        }
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        endBackgroundTask()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            // Auto-start if recording was pending (optional)
            break
        case .denied, .restricted:
            // Notify user or disable recording
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Ignore old or inaccurate points
        let now = Date()
        let age = now.timeIntervalSince(location.timestamp)
        if age > 10.0 {
            print("⚠️ Discarding stale location (age: \(age)s)")
            return
        }
        
        if location.horizontalAccuracy < 0 || location.horizontalAccuracy > 65 {
            print("⚠️ Low accuracy location: \(location.horizontalAccuracy)m")
            // You may still accept it, but consider filtering
        }
        
        // Update last known location
        lastLocation = location
        
        // Pass to ActivityManager if recording
        if ActivityManager.shared.isRecording {
            ActivityManager.shared.addLocation(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("📍 LocationManager error: \(error.localizedDescription)")
        // Optionally notify user or retry
    }
    
    // MARK: - Background Task Management
    
    private func startBackgroundTask() {
        endBackgroundTask() // Clean up any existing task
        backgroundTaskID = UIApplication.shared.beginBackgroundTask { [weak self] in
            // Expired – stop location to avoid crash
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
