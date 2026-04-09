//
//  DailyCheckInView.swift
//  Momentum
//
//  Created by Michael Shelton on 3/2/26.
//

import SwiftUI

struct DailyCheckInView: View {
    @Binding var habits: [Habit]
    @Binding var streakDays: Int

    private var todayString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: Date())
    }

    var body: some View {
        VStack(spacing: 14) {
            Text(todayString)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            List {
                ForEach($habits) { $habit in
                    if habit.isSelectedForCheckIn {
                        HStack {
                            Button {
                                habit.isDoneToday.toggle()
                            } label: {
                                Image(systemName: habit.isDoneToday ? "checkmark.square.fill" : "square")
                            }
                            .buttonStyle(.plain)

                            Text(habit.title)
                                .strikethrough(habit.isDoneToday)
                                .foregroundStyle(habit.isDoneToday ? .secondary : .primary)

                            Spacer()
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)

            Button {
                // placeholder: count completion and update streak simply
                let allSelected = habits.filter { $0.isSelectedForCheckIn }
                let completed = allSelected.filter { $0.isDoneToday }.count

                if completed > 0 {
                    streakDays += 1
                }
            } label: {
                Text("Complete Daily Check-In")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)

            Spacer(minLength: 6)
        }
        .padding(.top, 8)
        .navigationTitle("Daily Check-In")
        .navigationBarTitleDisplayMode(.inline)
    }
}
