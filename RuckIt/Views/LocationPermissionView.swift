//
//  LocationPermissionView.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/11/25.
//
import SwiftUI

struct LocationPermissionView: View {
    @Environment(LocationManager.self) private var locationManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "location.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.blue)
            
            Text("Location Access Required")
                .font(.title)
                .fontWeight(.bold)
            
            Text("RuckIt needs access to your location to track your distance, pace, and route during activities.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 16) {
                FeatureRow(icon: "figure.walk", title: "Track Distance", description: "Accurately measure how far you've traveled")
                FeatureRow(icon: "speedometer", title: "Monitor Pace", description: "See your real-time pace per kilometer")
                FeatureRow(icon: "map", title: "View Route", description: "Visualize your path on the map")
            }
            .padding()
            
            Spacer()
            
            VStack(spacing: 12) {
                Button {
                    locationManager.requestAuthorization()
                } label: {
                    Text("Enable Location Access")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                Button("Maybe Later") {
                    dismiss()
                }
                .foregroundStyle(.secondary)
            }
            .padding()
        }
        .padding()
        .onChange(of: locationManager.isAuthorized) { _, isAuthorized in
            if isAuthorized {
                dismiss()
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
    }
}
