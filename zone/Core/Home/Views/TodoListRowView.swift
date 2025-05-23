//
//  ListRowView.swift
//  zone
//
//  Created by Zulfikar Noorfan on 23/05/25.
//

import SwiftData
import SwiftUI

struct TodoListRowView: View {
    let item: TodoModel

    var body: some View {
        HStack {
            Button {
                // Toggle the todo's completion status
                item.toggleCompleted()
            } label: {
                Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                    .foregroundColor(item.isCompleted ? .green : .red)
            }
            .buttonStyle(PlainButtonStyle())

            Text(item.title)
                .font(.headline)
            Spacer()
        }
        .font(.title)
        .padding(.vertical, 8)
    }
}

#Preview {
    let goal = GoalModel(name: "Sample Goal", createdAt: .now)
    let todo = TodoModel(title: "Sample Todo", goal: goal)

    return TodoListRowView(item: todo)
        .padding()
}
