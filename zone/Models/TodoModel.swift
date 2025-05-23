//
//  TodosModel.swift
//  zone
//
//  Created by Zulfikar Noorfan on 20/05/25.
//

import Foundation
import SwiftData

@Model
final class TodoModel: Identifiable {
    var id: String
    var title: String
    var isCompleted: Bool

    // Relationship to parent goal
    @Relationship var goal: GoalModel

    init(
        id: String = UUID().uuidString,
        title: String,
        isCompleted: Bool = false,
        goal: GoalModel
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.goal = goal
    }

    func toggleCompleted() {
        isCompleted.toggle()
        // The goalPercentage will update automatically when accessed
        // No need to manually assign it since it's a computed property
    }
}
