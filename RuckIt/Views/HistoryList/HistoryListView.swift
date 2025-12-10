//
//  HistoryListView.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/10/25.
//
import SwiftUI

struct HistoryListView: View {
    @Environment(ActivityManager.self) var activityManager
    
    var body: some View {
        List(activityManager.activities.reversed(), id: \.id) { activity in
            NavigationLink(value: activity) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(activity.name)
                        .font(.headline)
                    Text("\(activity.type.rawValue.capitalized) • \(activity.duration.formatted(.units()))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("History")
    }
}
