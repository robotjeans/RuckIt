//
//  ActivityViewModel.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/10/25.
//
import Foundation
import SwiftUI
import Observation

@Observable
final class ActivityViewModel {
    var activities: [Activity] = []

    private var fileURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("activities.json")
    }

    func load() {
        do {
            let data = try Data(contentsOf: fileURL)
            activities = try JSONDecoder().decode([Activity].self, from: data)
        } catch {
            print("No saved activities or error loading: \(error)")
            activities = []
        }
    }

    func save() {
        do {
            let data = try JSONEncoder().encode(activities)
            try data.write(to: fileURL)
        } catch {
            print("Error saving activities: \(error)")
        }
    }

    func add(_ activity: Activity) {
        activities.append(activity)
        save()
    }

    func delete(at offsets: IndexSet) {
        activities.remove(atOffsets: offsets)
        save()
    }
}
