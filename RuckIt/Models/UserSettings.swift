//
//  UserSettings.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/10/25.
//
import Foundation

@Observable
class UserSettings {
    var weight: Double = 70.0 // kg — useful for calorie estimation in rucking
    var preferredMapType: String = "Standard"
    // Add more as needed
}
