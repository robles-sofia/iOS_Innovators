//
//  ContentView.swift
//  Momentum
//
//  Created by Michael Shelton on 2/26/26.
//

import SwiftUI

enum AppTab: Hashable {
    case home, today, stats, habits
}

struct ContentView: View {
    @State private var selectedTab: AppTab = .home

    // Shared app state (placeholder until backend)
    @State private var userName: String = "Name"
    @State private var streakDays: Int = 10

    @State private var habits: [Habit] = [
        Habit(title: "Morning run"),
        Habit(title: "Read 20 minutes"),
        Habit(title: "Drink water"),
        Habit(title: "Meditate")
    ]

    @State private var notificationsOn: Bool = false
    @State private var backgroundColor: Color = Color(.systemBackground)

    var body: some View {
        TabView(selection: $selectedTab) {

            NavigationStack {
                HomeView(
                    userName: $userName,
                    streakDays: $streakDays,
                    goTo: { tab in selectedTab = tab }
                )
                .background(backgroundColor.ignoresSafeArea())
            }
            .tabItem { Label("Home", systemImage: "house") }
            .tag(AppTab.home)

            NavigationStack {
                DailyCheckInView(
                    habits: $habits,
                    streakDays: $streakDays
                )
                .background(backgroundColor.ignoresSafeArea())
            }
            .tabItem { Label("Today", systemImage: "calendar") }
            .tag(AppTab.today)

            NavigationStack {
                StatsView(
                    streakDays: $streakDays,
                    habits: $habits
                )
                .background(backgroundColor.ignoresSafeArea())
            }
            .tabItem { Label("Stats", systemImage: "chart.bar") }
            .tag(AppTab.stats)

            NavigationStack {
                HabitsView(habits: $habits)
                    .background(backgroundColor.ignoresSafeArea())
                    .toolbar {
                        // Quick access to Settings from Habits (optional)
                        NavigationLink {
                            SettingsView(
                                userName: $userName,
                                backgroundColor: $backgroundColor,
                                notificationsOn: $notificationsOn
                            )
                        } label: {
                            Image(systemName: "gearshape")
                        }
                    }
            }
            .tabItem { Label("Habits", systemImage: "checklist") }
            .tag(AppTab.habits)
        }
    }
}
