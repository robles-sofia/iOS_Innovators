//
//  HomeView.swift
//  Momentum
//
//  Created by Michael Shelton on 3/2/26.
//

import SwiftUI

struct HomeView: View {
    @Binding var userName: String
    @Binding var streakDays: Int
    var goTo: (AppTab) -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Momentum")
                .font(.headline)
                .padding(.top, 6)

            Text("[Motivational Text]")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 10) {
                Text("☀️")
                Text("Good Morning, \(userName)!")
                    .font(.title3)
                    .fontWeight(.semibold)
            }

            VStack(spacing: 12) {
                Button {
                    goTo(.today)
                } label: {
                    Text("Start Daily Check-In")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Button {
                    goTo(.stats)
                } label: {
                    Text("Progress Dashboard")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button {
                    goTo(.habits)
                } label: {
                    Text("Habits")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                NavigationLink {
                    // Settings is not a tab in your mockup, so we push it
                    SettingsView(
                        userName: $userName,
                        backgroundColor: .constant(Color(.systemBackground)),
                        notificationsOn: .constant(false)
                    )
                } label: {
                    Text("Settings")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal)

            Spacer()

            HStack(spacing: 10) {
                Image(systemName: "flame.fill")
                Text("\(streakDays)-Day Streak")
                    .fontWeight(.semibold)
            }
            .padding(.bottom, 8)
        }
        .padding()
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
