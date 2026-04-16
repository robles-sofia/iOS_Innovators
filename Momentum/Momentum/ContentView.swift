//
//  ContentView.swift
//  Momentum
//
//  Created by Michael Shelton on 2/26/26.
//  Improved app looks and functionality by Brandon Baker on April 11
//

import SwiftUI

// enum used to track which tab is currently selected
// makes navigation easier instead of using numbers or strings
enum AppTab: Hashable {
    case home, today, stats, habits
}

struct ContentView: View {
    
    // keeps track of which tab is active
    @State private var selectedTab: AppTab = .home

    // saves user info so it stays even after closing the app
    @AppStorage("savedUserName") private var userName: String = "Name"
    @AppStorage("savedStreakDays") private var streakDays: Int = 0
    @AppStorage("lastCheckInDate") private var lastCheckInDate: String = ""

    // main habits list (updates UI automatically when changed)
    @State private var habits: [Habit] = []

    // settings values
    @State private var notificationsOn: Bool = false
    @State private var backgroundColor: Color = Color(.systemBackground)

    var body: some View {
        TabView(selection: $selectedTab) {

            // HOME TAB
            NavigationStack {
                HomeView(
                    userName: $userName,
                    streakDays: $streakDays,
                    goTo: { tab in selectedTab = tab } // allows navigation between tabs
                )
                .background(backgroundColor.ignoresSafeArea())
            }
            .tabItem { Label("Home", systemImage: "house") }
            .tag(AppTab.home)

            // DAILY CHECK-IN TAB
            NavigationStack {
                DailyCheckInView(
                    habits: $habits,
                    streakDays: $streakDays,
                    lastCheckInDate: $lastCheckInDate
                )
                .background(backgroundColor.ignoresSafeArea())
            }
            .tabItem { Label("Today", systemImage: "calendar") }
            .tag(AppTab.today)

            // STATS TAB
            NavigationStack {
                StatsView(
                    streakDays: $streakDays,
                    habits: $habits
                )
                .background(backgroundColor.ignoresSafeArea())
            }
            .tabItem { Label("Stats", systemImage: "chart.bar") }
            .tag(AppTab.stats)

            // HABITS TAB
            NavigationStack {
                HabitsView(habits: $habits)
                    .background(backgroundColor.ignoresSafeArea())
                    .toolbar {
                        // quick access to settings screen
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
        // loads saved habits when app starts
        .onAppear {
            loadHabits()
        }
        // saves habits anytime changes are made
        .onChange(of: habits) { _ in
            saveHabits()
        }
    }

    // saves habits to UserDefaults so data persists after closing app
    private func saveHabits() {
        do {
            let encodedHabits = try JSONEncoder().encode(habits)
            UserDefaults.standard.set(encodedHabits, forKey: "savedHabits")
        } catch {
            print("Could not save habits")
        }
    }

    // loads habits from storage or creates default ones if none exist
    private func loadHabits() {
        guard let savedData = UserDefaults.standard.data(forKey: "savedHabits") else {
            habits = [
                Habit(title: "Morning run"),
                Habit(title: "Read 20 minutes"),
                Habit(title: "Drink water"),
                Habit(title: "Meditate")
            ]
            return
        }

        do {
            habits = try JSONDecoder().decode([Habit].self, from: savedData)
        } catch {
            print("Could not load habits")
            
            // fallback in case decoding fails
            habits = [
                Habit(title: "Morning run"),
                Habit(title: "Read 20 minutes"),
                Habit(title: "Drink water"),
                Habit(title: "Meditate")
            ]
        }
    }
}
