//
//  ActivityViewModel.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/10/25.
//
import Combine

class ActivityViewModel: ObservableObject {
    @Published var activities: [Activity] = []


    func load() {
        // TODO: load from persistence
    }


    func add(_ activity: Activity) {
        activities.append(activity)
        // TODO: save
    }
}
