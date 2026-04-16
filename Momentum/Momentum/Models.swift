//
//  Models.swift
//  Momentum
//
//  Created by Michael Shelton on 3/2/26.
//  Updated data model and persistence support by Brandon Baker on April 13
//

import Foundation

// model used to represent a single habit in the app
// Identifiable allows it to work in lists
// Hashable allows comparison
// Codable allows saving/loading from UserDefaults
struct Habit: Identifiable, Hashable, Codable {
    
    // unique id for each habit
    let id: UUID
    
    // name of the habit
    var title: String
    
    // determines if habit shows up in daily check-in
    var isSelectedForCheckIn: Bool
    
    // tracks if habit is completed for the current day
    var isDoneToday: Bool

    // custom initializer so defaults can be set when creating habits
    init(
        id: UUID = UUID(),
        title: String,
        isSelectedForCheckIn: Bool = true,
        isDoneToday: Bool = false
    ) {
        self.id = id
        self.title = title
        self.isSelectedForCheckIn = isSelectedForCheckIn
        self.isDoneToday = isDoneToday
    }
}

// model used for chart data in StatsView
// represents how many habits were completed on a specific day
struct DayProgress: Identifiable {
    
    // unique id for chart rendering
    let id = UUID()
    
    // label for the day (Mon, Tue, etc.)
    let dayLabel: String
    
    // number of completed habits for that day
    let completedCount: Int
}
