//
//  TimeLogModel.swift
//  zone
//
//  Created by Zulfikar Noorfan on 23/05/25.
//

import Foundation
import SwiftData

@Model
final class TimeLogModel: Identifiable {
    var id: String
    var startTime: Date
    var endTime: Date
    var duration: TimeInterval
    var mode: TimerMode

    // Relationship to parent goal
    @Relationship var goal: GoalModel

    init(
        id: String = UUID().uuidString,
        startTime: Date,
        endTime: Date,
        duration: TimeInterval,
        mode: TimerMode,
        goal: GoalModel
    ) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
        self.mode = mode
        self.goal = goal
    }
}
