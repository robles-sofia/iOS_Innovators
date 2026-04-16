//
//  DailyCheckInView.swift
//  Momentum
//
//  Created by Michael Shelton on 3/2/26.
//  Improved app looks and functionality by Brandon Baker on April 11
//

import SwiftUI
import AVFoundation

struct DailyCheckInView: View {
    
    // bindings connect this view to ContentView so changes update everywhere
    @Binding var habits: [Habit]
    @Binding var streakDays: Int
    @Binding var lastCheckInDate: String

    // used for showing a random motivation message after check-in
    @State private var motivationMessage: String = ""
    @State private var showMotivationMessage = false

    // audio player for success sound
    @State private var audioPlayer: AVAudioPlayer?

    // list of possible motivation messages
    private let motivationMessages = [
        "Great job! Keep your momentum going.",
        "Nice work! Small progress still counts.",
        "You’re doing amazing. Stay consistent.",
        "Another step forward. Keep it up!",
        "Proud of you. Progress happens one day at a time."
    ]

    // formats today’s date for display at the top
    private var todayString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: Date())
    }

    // used to track if user already checked in today (prevents double streak count)
    private var todayKey: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }

    var body: some View {
        ZStack {
            // background gradient to give a more modern look
            LinearGradient(
                colors: [
                    Color(.systemGroupedBackground),
                    Color.blue.opacity(0.08)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {
                
                // shows today's date
                Text(todayString)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                // scrollable list of habits
                ScrollView {
                    VStack(spacing: 14) {
                        ForEach($habits) { $habit in
                            
                            // only show habits selected for check-in
                            if habit.isSelectedForCheckIn {
                                HStack(spacing: 14) {
                                    
                                    // checkbox button
                                    Button {
                                        habit.isDoneToday.toggle()
                                    } label: {
                                        Image(systemName: habit.isDoneToday ? "checkmark.square.fill" : "square")
                                            .font(.title2)
                                            .foregroundStyle(habit.isDoneToday ? .green : .gray)
                                    }
                                    .buttonStyle(.plain)

                                    // habit title with strike-through when completed
                                    Text(habit.title)
                                        .font(.headline)
                                        .strikethrough(habit.isDoneToday)
                                        .foregroundStyle(habit.isDoneToday ? .secondary : .primary)

                                    Spacer()
                                }
                                .padding()
                                .background(Color.white.opacity(0.95))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(radius: 2)
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // shows motivation message after check-in
                if showMotivationMessage {
                    Text(motivationMessage)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)
                        .transition(.opacity)
                }

                // main button to complete check-in
                Button {
                    completeCheckIn()
                } label: {
                    Text("Complete Daily Check-In")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
            .padding(.top, 8)
        }
        .navigationTitle("Daily Check-In")
        .navigationBarTitleDisplayMode(.inline)
    }

    // handles logic when user presses check-in button
    private func completeCheckIn() {
        let selectedHabits = habits.filter { $0.isSelectedForCheckIn }
        let completedHabits = selectedHabits.filter { $0.isDoneToday }

        // prevents streak from updating if nothing is selected or completed
        guard !selectedHabits.isEmpty else { return }
        guard !completedHabits.isEmpty else { return }

        // only increase streak once per day
        if lastCheckInDate != todayKey {
            streakDays += 1
            lastCheckInDate = todayKey
        }

        // pick random motivation message
        motivationMessage = motivationMessages.randomElement() ?? "Nice job!"

        // show message with animation
        withAnimation {
            showMotivationMessage = true
        }

        // play success sound
        playSuccessSound()

        // hide message after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                showMotivationMessage = false
            }
        }
    }

    // plays sound when check-in is completed
    private func playSuccessSound() {
        guard let soundURL = Bundle.main.url(forResource: "success", withExtension: "mp3") else {
            print("Sound file not found")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Could not play sound")
        }
    }
}
