//
//  ContentView.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/10/25.
//
import SwiftUI

struct ContentView: View {
    @State private var activityViewModel = ActivityViewModel()
    @State private var selectedTab = 0
    @State private var showPreRecordingSheet = false

    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
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
            
            // Record Tab (Center - Shows sheet)
            Color.clear
                .tabItem {
                    Label("Record", systemImage: "plus.circle.fill")
                }
                .tag(1)
            
            // History Tab
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
        .environment(ActivityManager.shared)
        .environment(LocationManager.shared)
        .environment(activityViewModel)
        .environment(UserProfile.shared)
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
            get: { ActivityManager.shared.isRecording },
            set: { _ in }
        )) {
            NavigationStack {
                RecordActivityView()
            }
        }
        .onAppear {
            activityViewModel.load()
        }
    }
}
