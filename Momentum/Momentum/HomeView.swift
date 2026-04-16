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
        ZStack {
            // soft background so the screen feels less plain
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
                VStack(alignment: .leading, spacing: 20) {

                    // app title area
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Momentum")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("Build better routines one day at a time.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 10)

                    // greeting card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("☀️")
                                .font(.title2)

                            Text("Good Morning, \(userName)!")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }

                        Text("Stay consistent today and keep your progress moving forward.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 4)

                    // streak card
                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(Color.orange.opacity(0.2))
                                .frame(width: 55, height: 55)

                            Image(systemName: "flame.fill")
                                .font(.title2)
                                .foregroundStyle(.orange)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(streakDays)-Day Streak")
                                .font(.title3)
                                .fontWeight(.bold)

                            Text("You're building strong habits.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 4)

                    // section title
                    Text("Quick Actions")
                        .font(.headline)
                        .padding(.horizontal, 4)

                    VStack(spacing: 14) {
                        HomeActionCard(
                            title: "Start Daily Check-In",
                            subtitle: "Track what you finish today",
                            icon: "checkmark.circle.fill",
                            iconColor: .green
                        ) {
                            goTo(.today)
                        }

                        HomeActionCard(
                            title: "Progress Dashboard",
                            subtitle: "See your weekly habit progress",
                            icon: "chart.bar.fill",
                            iconColor: .blue
                        ) {
                            goTo(.stats)
                        }

                        HomeActionCard(
                            title: "Manage Habits",
                            subtitle: "Add, remove, and organize habits",
                            icon: "list.bullet.rectangle.fill",
                            iconColor: .purple
                        ) {
                            goTo(.habits)
                        }

                        NavigationLink {
                            // Settings is not a tab in your mockup, so we push it
                            SettingsView(
                                userName: $userName,
                                backgroundColor: .constant(Color(.systemBackground)),
                                notificationsOn: .constant(false)
                            )
                        } label: {
                            HStack(spacing: 14) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray.opacity(0.15))
                                        .frame(width: 44, height: 44)

                                    Image(systemName: "gearshape.fill")
                                        .foregroundStyle(.gray)
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Settings")
                                        .font(.headline)
                                        .foregroundStyle(.primary)

                                    Text("Customize your app preferences")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .shadow(radius: 3)
                        }
                    }

                    Spacer(minLength: 20)
                }
                .padding()
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// reusable card for the home buttons
struct HomeActionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let iconColor: Color
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 44, height: 44)

                    Image(systemName: icon)
                        .foregroundStyle(iconColor)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color.white.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(radius: 3)
        }
        .buttonStyle(.plain)
    }
}
