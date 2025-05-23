//
//  AddGoalViewModel.swift
//  zone
//
//  Created by Zulfikar Noorfan on 23/05/25.
//

import Foundation
import SwiftData

@MainActor
final class AddGoalViewModel: ObservableObject {
    @Published var goalName = ""
    @Published var todos: [String] = []
    @Published private(set) var isValid = false

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func addTodo(_ title: String) {
        guard !title.isEmpty else { return }
        todos.append(title)
        validateForm()
    }

    func removeTodo(at index: Int) {
        todos.remove(at: index)
        validateForm()
    }

    private func validateForm() {
        let trimmedName = goalName.trimmingCharacters(in: .whitespacesAndNewlines)
        isValid = trimmedName.count >= 3 && !todos.isEmpty
    }

    func save() {
        let trimmedName = goalName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard isValid, !trimmedName.isEmpty else { return }

        let goal = GoalModel(name: trimmedName, createdAt: .now)

        // Create todos for the goal
        for todoTitle in todos {
            let todo = TodoModel(title: todoTitle, goal: goal)
            goal.todos.append(todo)
        }

        // Save to SwiftData
        modelContext.insert(goal)

        do {
            try modelContext.save()
            // Reset form
            goalName = ""
            todos = []
            validateForm()
        } catch {
            print("Failed to save goal: \(error)")
        }
    }
}
