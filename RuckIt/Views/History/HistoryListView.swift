//
//  HistoryListView.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/10/25.
//
import SwiftUI

struct HistoryListView: View {
    @Environment(ActivityViewModel.self) private var activityViewModel
    
    var body: some View {
        List {
            ForEach(activityViewModel.activities.reversed()) { activity in
                NavigationLink(value: activity) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(activity.name)
                            .font(.headline)
                        HStack {
                            Text(activity.type.rawValue.capitalized)
                            Text("•")
                            Text(formattedDuration(activity.duration))
                            Text("•")
                            Text(String(format: "%.2f km", activity.distance / 1000))
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                }
            }
            .onDelete { indexSet in
                activityViewModel.delete(at: indexSet)
            }
        }
        .navigationTitle("History")
        .toolbar {
            EditButton()
        }
    }
    
    private func formattedDuration(_ timeInterval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: timeInterval) ?? "0m"
    }
}
