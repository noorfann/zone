//
//  AddGoalView.swift
//  zone
//
//  Created by Zulfikar Noorfan on 23/05/25.
//

import SwiftData
import SwiftUI

struct AddGoalView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AddGoalViewModel
    @State private var todoTitle = ""

    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: AddGoalViewModel(modelContext: modelContext))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Goal") {
                    TextField("Goal Name", text: $viewModel.goalName)
                        .textInputAutocapitalization(.none)
                }

                Section("Todos") {
                    ForEach(viewModel.todos.indices, id: \.self) { index in
                        HStack {
                            Text(viewModel.todos[index])
                            Spacer()
                            Button(role: .destructive) {
                                viewModel.removeTodo(at: index)
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }

                    HStack {
                        TextField("New Todo", text: $todoTitle)
                            .textInputAutocapitalization(.none)
                        Button("Add") {
                            viewModel.addTodo(todoTitle)
                            todoTitle = ""
                        }
                        .disabled(todoTitle.isEmpty)
                    }
                }

                Section {
                    Button("Save Goal") {
                        viewModel.save()
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(!viewModel.isValid)
                }
            }
            .navigationTitle("New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddGoalView(modelContext: ModelContext(try! ModelContainer(for: GoalModel.self)))
}
