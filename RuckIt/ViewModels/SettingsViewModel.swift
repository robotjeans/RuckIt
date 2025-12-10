//
//  SettingsViewModel.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/10/25.
//
import Combine

class SettingsViewModel: ObservableObject {
    @Published var weight: Double = 0 // ruck weight
    @Published var unitsMetric = true
}
