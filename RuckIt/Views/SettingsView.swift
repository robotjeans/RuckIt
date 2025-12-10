//
//  SettingsView.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/11/25.
//
import SwiftUI

struct SettingsView: View {
    @Environment(UserProfile.self) private var userProfile
    @Environment(LocationManager.self) private var locationManager
    @Environment(ActivityViewModel.self) private var activityViewModel
    
    @State private var weight: String = ""
    @State private var height: String = ""
    @State private var age: String = ""
    @State private var selectedGender: UserProfile.Gender = .male
    @State private var useMetric: Bool = true
    
    @State private var showDeleteConfirmation = false
    @State private var showProfileSavedAlert = false
    
    var body: some View {
        Form {
            // User Profile Section
            Section {
                HStack {
                    Text("Weight")
                    Spacer()
                    TextField("0", text: $weight)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                    Text(useMetric ? "kg" : "lbs")
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("Height")
                    Spacer()
                    TextField("0", text: $height)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                    Text(useMetric ? "cm" : "in")
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("Age")
                    Spacer()
                    TextField("0", text: $age)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                    Text("years")
                        .foregroundStyle(.secondary)
                }
                
                Picker("Gender", selection: $selectedGender) {
                    ForEach(UserProfile.Gender.allCases, id: \.self) { gender in
                        Text(gender.rawValue).tag(gender)
                    }
                }
                
                Button("Save Profile") {
                    saveProfile()
                }
                .frame(maxWidth: .infinity)
                .disabled(!isProfileValid)
                
            } header: {
                Text("Your Profile")
            } footer: {
                Text("This information is used to calculate calories burned during activities.")
            }
            
            // Units Section
            Section {
                Toggle("Use Metric Units", isOn: $useMetric)
            } header: {
                Text("Units")
            } footer: {
                Text(useMetric ? "Distance in km, weight in kg, height in cm" : "Distance in miles, weight in lbs, height in inches")
            }
            
            // Location Permission Section
            Section {
                HStack {
                    Text("Location Access")
                    Spacer()
                    if locationManager.isAuthorized {
                        Text("Enabled")
                            .foregroundStyle(.green)
                    } else if locationManager.isDenied {
                        Text("Denied")
                            .foregroundStyle(.red)
                    } else {
                        Text("Not Set")
                            .foregroundStyle(.orange)
                    }
                }
                
                if locationManager.isDenied {
                    Button("Open Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                } else if !locationManager.isAuthorized {
                    Button("Request Permission") {
                        locationManager.requestAuthorization()
                    }
                }
            } header: {
                Text("Permissions")
            }
            
            // Data Management Section
            Section {
                HStack {
                    Text("Activities Recorded")
                    Spacer()
                    Text("\(activityViewModel.activities.count)")
                        .foregroundStyle(.secondary)
                }
                
                if !activityViewModel.activities.isEmpty {
                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Text("Delete All Activities")
                    }
                }
            } header: {
                Text("Data")
            } footer: {
                Text("All data is stored locally on your device.")
            }
            
            // App Info Section
            Section {
                HStack {
                    Text("Version")
                    Spacer()
                    Text(appVersion)
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("Build")
                    Spacer()
                    Text(buildNumber)
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text("About")
            }
        }
        .navigationTitle("Settings")
        .alert("Profile Saved", isPresented: $showProfileSavedAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your profile has been updated successfully.")
        }
        .alert("Delete All Activities?", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete All", role: .destructive) {
                deleteAllActivities()
            }
        } message: {
            Text("This will permanently delete all \(activityViewModel.activities.count) activities. This action cannot be undone.")
        }
        .onAppear {
            loadProfileData()
        }
    }
        
    private var isProfileValid: Bool {
        guard let weightValue = Double(weight), weightValue > 0,
              let heightValue = Double(height), heightValue > 0,
              let ageValue = Int(age), ageValue > 0 else {
            return false
        }
        return true
    }
    
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
        
    private func loadProfileData() {
        if let savedWeight = userProfile.weight {
            weight = String(format: "%.1f", useMetric ? savedWeight : savedWeight * 2.20462)
        }
        
        if let savedHeight = userProfile.height {
            height = String(format: "%.1f", useMetric ? savedHeight : savedHeight * 0.393701)
        }
        
        if let savedAge = userProfile.age {
            age = String(savedAge)
        }
        
        if let savedGender = userProfile.gender {
            selectedGender = savedGender
        }
    }
    
    private func saveProfile() {
        guard let weightValue = Double(weight),
              let heightValue = Double(height),
              let ageValue = Int(age) else {
            return
        }
        
        // Convert to metric if needed
        userProfile.weight = useMetric ? weightValue : weightValue * 0.453592
        userProfile.height = useMetric ? heightValue : heightValue * 2.54
        userProfile.age = ageValue
        userProfile.gender = selectedGender
        
        userProfile.save()
        showProfileSavedAlert = true
    }
    
    private func deleteAllActivities() {
        activityViewModel.activities.removeAll()
        activityViewModel.save()
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environment(UserProfile.shared)
            .environment(LocationManager.shared)
            .environment(ActivityViewModel())
    }
}
