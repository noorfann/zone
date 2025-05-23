//
//  GoalModel.swift
//  zone
//
//  Created by Zulfikar Noorfan on 20/05/25.
//

import Foundation
import SwiftData

@Model
final class GoalModel: Identifiable {
    var id: String
    var name: String
    var createdAt: Date

    // Relationships with cascade deletion
    @Relationship(deleteRule: .cascade) var todos: [TodoModel] = []
    @Relationship(deleteRule: .cascade) var timeLogs: [TimeLogModel] = []

    // Computed properties
    var timeSpent: TimeInterval {
        timeLogs.reduce(0) { $0 + $1.duration }
    }

    var todosCount: Int {
        todos.count
    }

    var goalPercentage: Double {
        guard !todos.isEmpty else { return 0 }
        let completedCount = todos.filter { $0.isCompleted }.count
        return Double(completedCount) / Double(todos.count) * 100
    }

    init(
        id: String = UUID().uuidString,
        name: String,
        createdAt: Date,
        todos: [TodoModel] = [],
        timeLogs: [TimeLogModel] = []
    ) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.todos = todos
        self.timeLogs = timeLogs
    }
}
