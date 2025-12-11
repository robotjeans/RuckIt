//
//  ContentView.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/10/25.
//
import SwiftUI

struct ContentView: View {
    @Environment(ActivityManager.self) private var activityManager
    @State private var selectedTab = 0
    @State private var showPreRecordingSheet = false

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                HomeView()
                    .navigationDestination(for: Activity.self) { activity in
                        ActivityDetailView(activity: activity)
                    }
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(0)
            
            Color.clear
                .tabItem {
                    Label("Record", systemImage: "plus.circle.fill")
                }
                .tag(1)
            
            NavigationStack {
                HistoryListView()
                    .navigationDestination(for: Activity.self) { activity in
                        ActivityDetailView(activity: activity)
                    }
            }
            .tabItem {
                Label("History", systemImage: "list.bullet")
            }
            .tag(2)
        }
        .onChange(of: selectedTab) { oldValue, newValue in
            if newValue == 1 {
                showPreRecordingSheet = true
                selectedTab = oldValue
            }
        }
        .sheet(isPresented: $showPreRecordingSheet) {
            PreRecordingSetupView()
        }
        .fullScreenCover(isPresented: Binding(
            get: { activityManager.isRecording },
            set: { _ in }
        )) {
            NavigationStack {
                RecordActivityView()
            }
        }
    }
}
