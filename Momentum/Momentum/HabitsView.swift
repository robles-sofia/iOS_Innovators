//
//  HabitsView.swift
//  Momentum
//
//  Created by Michael Shelton on 3/2/26.
//

import SwiftUI

struct HabitsView: View {
    @Binding var habits: [Habit]
    @State private var newHabitTitle: String = ""
    @State private var showingAdd = false
    @State private var isSelecting = false

    var body: some View {
        VStack {
            List {
                ForEach($habits) { $habit in
                    HStack {
                        if isSelecting {
                            Button {
                                habit.isSelectedForCheckIn.toggle()
                            } label: {
                                Image(systemName: habit.isSelectedForCheckIn ? "checkmark.circle.fill" : "circle")
                            }
                            .buttonStyle(.plain)
                        }

                        Text(habit.title)

                        Spacer()

                        Button { } label: { Image(systemName: "pencil") }
                            .buttonStyle(.plain)

                        Button {
                            habits.removeAll { $0.id == habit.id }
                        } label: {
                            Image(systemName: "trash")
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .listStyle(.insetGrouped)

            HStack {
                Button {
                    showingAdd = true
                } label: {
                    Label("Add Habit", systemImage: "plus")
                }

                Spacer()

                Button {
                    isSelecting.toggle()
                } label: {
                    Text(isSelecting ? "Done" : "Display")
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .navigationTitle("Habits")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAdd) {
            NavigationStack {
                Form {
                    TextField("Habit name", text: $newHabitTitle)
                }
                .navigationTitle("New Habit")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            newHabitTitle = ""
                            showingAdd = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add") {
                            let trimmed = newHabitTitle.trimmingCharacters(in: .whitespacesAndNewlines)
                            guard !trimmed.isEmpty else { return }
                            habits.append(Habit(title: trimmed))
                            newHabitTitle = ""
                            showingAdd = false
                        }
                    }
                }
            }
        }
    }
}
