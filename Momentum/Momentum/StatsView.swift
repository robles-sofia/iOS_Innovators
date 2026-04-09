//
//  StatsView.swift
//  Momentum
//
//  Created by Michael Shelton on 3/2/26.
//

import SwiftUI
import Charts

struct StatsView: View {
    @Binding var streakDays: Int
    @Binding var habits: [Habit]

    private var weekData: [DayProgress] {
        // placeholder data (replace later with real stats)
        [
            DayProgress(dayLabel: "Mon", completedCount: 2),
            DayProgress(dayLabel: "Tue", completedCount: 4),
            DayProgress(dayLabel: "Wed", completedCount: 3),
            DayProgress(dayLabel: "Thu", completedCount: 5),
            DayProgress(dayLabel: "Fri", completedCount: 4),
            DayProgress(dayLabel: "Sat", completedCount: 1),
            DayProgress(dayLabel: "Sun", completedCount: 3)
        ]
    }

    var body: some View {
        VStack(spacing: 14) {
            VStack(spacing: 6) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 44))
                Text("\(streakDays) Days")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Weekly Progress")
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 8)

            Chart(weekData) { item in
                BarMark(
                    x: .value("Day", item.dayLabel),
                    y: .value("Completed", item.completedCount)
                )
            }
            .frame(height: 220)
            .padding()

            Text("[Summary stats / percentages]")
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding()
        .navigationTitle("Stats")
        .navigationBarTitleDisplayMode(.inline)
    }
}
