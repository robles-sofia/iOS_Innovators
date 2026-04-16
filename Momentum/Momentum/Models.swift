//
//  Models.swift
//  Momentum
//
//  Created by Michael Shelton on 3/2/26.
//

import Foundation

struct Habit: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var isSelectedForCheckIn: Bool = true
    var isDoneToday: Bool = false
}

struct DayProgress: Identifiable {
    let id = UUID()
    let dayLabel: String
    let completedCount: Int
}
