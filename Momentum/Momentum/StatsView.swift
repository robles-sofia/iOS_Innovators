//
//  StatsView.swift
//  Momentum
//
//  Created by Michael Shelton on 3/2/26.
//  Improved app looks and functionality by Brandon Baker on April 13
//

import SwiftUI
import Charts

struct StatsView: View {
    
    // bindings let this screen read shared app data from ContentView
    @Binding var streakDays: Int
    @Binding var habits: [Habit]

    // counts how many habits were completed today
    private var completedToday: Int {
        habits.filter { $0.isDoneToday }.count
    }

    // counts how many habits are selected to appear in daily check-in
    private var selectedForCheckIn: Int {
        habits.filter { $0.isSelectedForCheckIn }.count
    }

    // total number of habits in the app
    private var totalHabits: Int {
        habits.count
    }

    // calculates completion percent based on selected habits
    private var completionPercentage: Int {
        guard selectedForCheckIn > 0 else { return 0 }
        return Int((Double(completedToday) / Double(selectedForCheckIn)) * 100)
    }

    // creates simple chart data for the week
    // right now only today's value is filled in based on completed tasks
    private var weekData: [DayProgress] {
        let dayLabels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

        var values = dayLabels.map { DayProgress(dayLabel: $0, completedCount: 0) }

        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: Date())

        // Sunday = 1, Monday = 2, etc.
        let indexMap: [Int: Int] = [
            2: 0, // Mon
            3: 1, // Tue
            4: 2, // Wed
            5: 3, // Thu
            6: 4, // Fri
            7: 5, // Sat
            1: 6  // Sun
        ]

        // puts today's completed amount in the correct weekday spot
        if let todayIndex = indexMap[weekday] {
            values[todayIndex] = DayProgress(
                dayLabel: dayLabels[todayIndex],
                completedCount: completedToday
            )
        }

        return values
    }

    // finds which day has the highest completion count
    private var bestDay: String {
        weekData.max(by: { $0.completedCount < $1.completedCount })?.dayLabel ?? "N/A"
    }

    var body: some View {
        ZStack {
            // background gradient for a cleaner modern look
            LinearGradient(
                colors: [
                    Color(.systemGroupedBackground),
                    Color.blue.opacity(0.08)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {

                    // streak card at the top
                    VStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(Color.orange.opacity(0.18))
                                .frame(width: 75, height: 75)

                            Image(systemName: "flame.fill")
                                .font(.system(size: 34))
                                .foregroundStyle(.orange)
                        }

                        Text("\(streakDays) Days")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("Current Streak")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.opacity(0.95))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(radius: 3)

                    // chart card showing weekly progress
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Weekly Progress")
                            .font(.title3)
                            .fontWeight(.semibold)

                        Chart(weekData) { item in
                            BarMark(
                                x: .value("Day", item.dayLabel),
                                y: .value("Completed", item.completedCount)
                            )
                            .cornerRadius(6)
                        }
                        .frame(height: 240)
                    }
                    .padding()
                    .background(Color.white.opacity(0.95))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(radius: 3)

                    // stat cards for quick info
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            statsCard(title: "Total Habits", value: "\(totalHabits)", icon: "list.bullet")
                            statsCard(title: "Done Today", value: "\(completedToday)", icon: "checkmark.circle.fill")
                        }

                        HStack(spacing: 12) {
                            statsCard(title: "Selected", value: "\(selectedForCheckIn)", icon: "slider.horizontal.3")
                            statsCard(title: "Completion", value: "\(completionPercentage)%", icon: "chart.pie.fill")
                        }
                    }

                    // summary section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Summary")
                            .font(.title3)
                            .fontWeight(.semibold)

                        Text("Today you completed \(completedToday) out of \(selectedForCheckIn) selected habits. Your completion rate is \(completionPercentage)%. Your current best day showing on the chart is \(bestDay).")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.white.opacity(0.95))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(radius: 3)
                }
                .padding()
            }
        }
        .navigationTitle("Stats")
        .navigationBarTitleDisplayMode(.inline)
    }

    // reusable card used for the small stat boxes
    private func statsCard(title: String, value: String, icon: String) -> some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.15))
                    .frame(width: 46, height: 46)

                Image(systemName: icon)
                    .foregroundStyle(.blue)
            }

            Text(value)
                .font(.title2)
                .fontWeight(.bold)

            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 130)
        .padding()
        .background(Color.white.opacity(0.95))
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .shadow(radius: 2)
    }
}
