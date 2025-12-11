//
//  HomeView.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/10/25.
//
import SwiftUI
import CoreLocation

struct HomeView: View {
    @Environment(ActivityManager.self) private var activityManager
    @Environment(LocationManager.self) private var locationManager
    @Environment(ActivityViewModel.self) private var activityViewModel
    
    @State private var showPermissionSheet = false
    
    private func formattedDuration(_ timeInterval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: timeInterval) ?? "0s"
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            Text("RuckIt")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Location Permission Banner
            if locationManager.isDenied {
                LocationPermissionBanner()
            }
            
            // Quick Summary
            if let last = activityViewModel.activities.last {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Last Activity")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Text(last.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                    HStack {
                        Label(formattedDuration(last.duration), systemImage: "clock")
                        Spacer()
                        Label(String(format: "%.2f km", last.distance / 1000), systemImage: "figure.walk")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.secondary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            // Start Button
            Button(action: {
                if locationManager.isAuthorized {
                    // Recording handled by tab bar
                } else {
                    showPermissionSheet = true
                }
            }) {
                Label("Start New Ruck", systemImage: "figure.walk")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .disabled(!locationManager.isLocationAvailable)
            
            Spacer()
            
            // Bottom Nav
            HStack(spacing: 32) {
                NavigationLink {
                    HistoryListView()
                } label: {
                    Label("History", systemImage: "list.bullet")
                }
                
                Spacer()
            }
            .font(.headline)
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    ProfileView()
                } label: {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.blue)
                }
            }
        }
        .sheet(isPresented: $showPermissionSheet) {
            LocationPermissionView()
        }
        .onAppear {
            if locationManager.authorizationStatus == .notDetermined {
                showPermissionSheet = true
            }
        }
    }
}

