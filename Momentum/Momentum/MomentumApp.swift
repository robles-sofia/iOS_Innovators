//
//  MomentumApp.swift
//  Momentum
//
//  Created by Michael Shelton on 2/26/26.
//  Added onboarding flow and app launch logic by Brandon Baker on April 14
//

import SwiftUI

@main
struct MomentumApp: App {
    
    // tracks if user has completed onboarding
    // stored so it persists even after closing the app
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    // stores user's name from onboarding
    @AppStorage("savedUserName") private var savedUserName = ""

    var body: some Scene {
        WindowGroup {
            
            // decides which screen to show when app launches
            // if onboarding is done -> go to main app
            // if not -> show onboarding first
            if hasCompletedOnboarding {
                ContentView()
            } else {
                OnboardingView()
            }
        }
    }
}
