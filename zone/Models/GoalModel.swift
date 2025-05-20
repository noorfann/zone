//
//  GoalModel.swift
//  zone
//
//  Created by Zulfikar Noorfan on 20/05/25.
//

import Foundation
import SwiftData

@Model
final class GoalModel {
    var id: String
    var name: String
    var date: Date
    var timeSpent: TimeInterval
    var todosCount : Int
    var goalPercentage: Double
    
    init(id: String = UUID().uuidString, name: String, date: Date, timeSpent: TimeInterval, todosCount: Int, goalPercentage: Double) {
        self.id = id
        self.name = name
        self.date = date
        self.timeSpent = timeSpent
        self.todosCount = todosCount
        self.goalPercentage = goalPercentage
    }
}
