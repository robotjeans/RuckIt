//
//  SettingsView.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/10/25.
//
import SwiftUI

struct SettingsView: View {
    @State private var userWeight: String = "70"
    
    var body: some View {
        Form {
            Section("User") {
                TextField("Weight (kg)", text: $userWeight)
                    .keyboardType(.decimalPad)
            }
            
            Section("Map") {
                // Add map style picker later
                Text("Map Style: Standard")
            }
            
            Section {
                Button("Export Data", role: .none) {
                    // Implement later
                }
                Button("Clear All Activities", role: .destructive) {
                    // Confirm + delete
                }
            }
        }
        .navigationTitle("Settings")
    }
}
