//
//  HomeView.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/10/25.
//
import SwiftUI

struct HomeView: View {
    @Environment(ActivityManager.self) var activityManager
    @Environment(LocationManager.self) var locationManager
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            Text("RuckIt")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Quick Summary
            if let last = activityManager.activities.last {
                VStack(alignment: .leading) {
                    Text("Last Activity")
                        .font(.headline)
                    Text("\(last.name) • \(last.duration.formatted(.units()))")
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.secondary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            // Start Button
            Button(action: {
                activityManager.startNewActivity(name: "Untitled Ruck", type: .ruck)
            }) {
                Text("Start New Ruck")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            
            Spacer()
            
            // Bottom Nav
            HStack {
                NavigationLink("History") {
                    HistoryListView()
                }
                Spacer()
                NavigationLink("Settings") {
                    SettingsView()
                }
            }
            .font(.headline)
            .padding(.horizontal)
        }
        .padding()
        .navigationTitle("RuckIt")
    }
}
