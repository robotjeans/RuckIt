//
//  ContentView.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/10/25.
//
import SwiftUI

struct ContentView: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            HomeView()
                .navigationDestination(for: Activity.self) { activity in
                    ActivityDetailView(activity: activity)
                }
                .navigationDestination(
                    isPresented: Binding(
                        get: { ActivityManager.shared.isRecording },
                        set: { ActivityManager.shared.isRecording = $0 }
                    )
                ) {
                    RecordActivityView()
                }
        }
        .environment(ActivityManager.shared)
        .environment(LocationManager.shared)
    }
}
