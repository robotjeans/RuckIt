//
//  PreRecordingSetupView.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/11/25.
//
import SwiftUI

struct PreRecordingSetupView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(UserProfile.self) private var userProfile
    @Environment(ActivityManager.self) private var activityManager
    @Environment(LocationManager.self) private var locationManager
    
    @State private var ruckWeight: Double = 0
    @State private var userWeight: Double = 0
    @State private var userHeight: Double = 0
    @State private var userAge: String = ""
    @State private var selectedGender: UserProfile.Gender = .male
    @State private var activityName: String = ""
    @State private var activityType: ActivityType = .ruck
    
    @State private var useMetric: Bool = true
    
    private var needsProfileInfo: Bool {
        !userProfile.isProfileComplete
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // Activity Details Section
                Section("Activity Details") {
                    TextField("Activity Name", text: $activityName)
                        .textInputAutocapitalization(.words)
                    
                    Picker("Type", selection: $activityType) {
                        ForEach(ActivityType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                }
                
                // Ruck Weight Section (Always shown)
                Section {
                    HStack {
                        Text("Ruck Weight")
                        Spacer()
                        TextField("0", value: $ruckWeight, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        Text(useMetric ? "kg" : "lbs")
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("Equipment")
                } footer: {
                    Text("Enter the weight of your ruck/backpack")
                }
                
                // User Profile Section (Only if not complete)
                if needsProfileInfo {
                    Section {
                        if userProfile.weight == nil {
                            HStack {
                                Text("Your Weight")
                                Spacer()
                                TextField("0", value: $userWeight, format: .number)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                                    .frame(width: 80)
                                Text(useMetric ? "kg" : "lbs")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        if userProfile.height == nil {
                            HStack {
                                Text("Height")
                                Spacer()
                                TextField("0", value: $userHeight, format: .number)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                                    .frame(width: 80)
                                Text(useMetric ? "cm" : "in")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        if userProfile.age == nil {
                            HStack {
                                Text("Age")
                                Spacer()
                                TextField("0", text: $userAge)
                                    .keyboardType(.numberPad)
                                    .multilineTextAlignment(.trailing)
                                    .frame(width: 80)
                                Text("years")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        if userProfile.gender == nil {
                            Picker("Gender", selection: $selectedGender) {
                                ForEach(UserProfile.Gender.allCases, id: \.self) { gender in
                                    Text(gender.rawValue).tag(gender)
                                }
                            }
                        }
                        
                        Toggle("Use Metric Units", isOn: $useMetric)
                    } header: {
                        Text("Your Profile")
                    } footer: {
                        Text("This information helps calculate calories burned. It will be saved for future activities.")
                    }
                }
                
                // Units Toggle (if profile already complete)
                if !needsProfileInfo {
                    Section {
                        Toggle("Use Metric Units", isOn: $useMetric)
                    }
                }
            }
            .navigationTitle("Start Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Start") {
                        startRecording()
                    }
                    .disabled(!isFormValid)
                }
            }
            .onAppear {
                // Pre-fill with saved profile data
                if let weight = userProfile.weight {
                    userWeight = weight
                }
                if let height = userProfile.height {
                    userHeight = height
                }
                if let age = userProfile.age {
                    userAge = String(age)
                }
                if let gender = userProfile.gender {
                    selectedGender = gender
                }
                
                // Default activity name
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM d"
                activityName = "\(activityType.rawValue.capitalized) - \(formatter.string(from: Date()))"
            }
        }
    }
    
    private var isFormValid: Bool {
        // Activity name is required
        guard !activityName.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        
        // If profile is incomplete, validate those fields
        if needsProfileInfo {
            if userProfile.weight == nil && userWeight <= 0 { return false }
            if userProfile.height == nil && userHeight <= 0 { return false }
            if userProfile.age == nil && (userAge.isEmpty || Int(userAge) == nil) { return false }
        }
        
        return true
    }
    
    private func startRecording() {
        // Save profile data if needed
        if needsProfileInfo {
            if userProfile.weight == nil {
                userProfile.weight = useMetric ? userWeight : userWeight * 0.453592 // lbs to kg
            }
            if userProfile.height == nil {
                userProfile.height = useMetric ? userHeight : userHeight * 2.54 // inches to cm
            }
            if userProfile.age == nil, let age = Int(userAge) {
                userProfile.age = age
            }
            if userProfile.gender == nil {
                userProfile.gender = selectedGender
            }
            userProfile.save()
        }
        
        // Convert ruck weight to kg if needed
        let ruckWeightKg = useMetric ? ruckWeight : ruckWeight * 0.453592
        
        // Start recording with all the data
        activityManager.startNewActivity(
            name: activityName,
            type: activityType,
            ruckWeight: ruckWeightKg
        )
        locationManager.startUpdatingLocation()
        
        dismiss()
    }
}
