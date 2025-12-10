//
//  UserProfile.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/11/25.
//
import Foundation
import Observation

@Observable
final class UserProfile {
    static let shared = UserProfile()
    
    var weight: Double? // kg
    var height: Double? // cm
    var age: Int?
    var gender: Gender?
    
    enum Gender: String, Codable, CaseIterable {
        case male = "Male"
        case female = "Female"
        case other = "Other"
    }
    
    var isProfileComplete: Bool {
        weight != nil && height != nil && age != nil && gender != nil
    }
    
    private init() {
        load()
    }
        
    private var fileURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("userProfile.json")
    }
    
    func load() {
        do {
            let data = try Data(contentsOf: fileURL)
            let profile = try JSONDecoder().decode(ProfileData.self, from: data)
            self.weight = profile.weight
            self.height = profile.height
            self.age = profile.age
            self.gender = profile.gender
        } catch {
            print("No saved profile: \(error)")
        }
    }
    
    func save() {
        do {
            let profile = ProfileData(weight: weight, height: height, age: age, gender: gender)
            let data = try JSONEncoder().encode(profile)
            try data.write(to: fileURL)
        } catch {
            print("Error saving profile: \(error)")
        }
    }
    
    private struct ProfileData: Codable {
        let weight: Double?
        let height: Double?
        let age: Int?
        let gender: Gender?
    }
}
