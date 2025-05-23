//
//  HomeView.swift
//  zone
//
//  Created by Zulfikar Noorfan on 20/05/25.
//

import SwiftData
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @State private var showingAddGoal = false
    @State private var goalToDelete: GoalModel?
    @State private var showingDeleteConfirmation = false

    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(modelContext: modelContext))
    }

    private func confirmDeleteGoal(_ goal: GoalModel) {
        goalToDelete = goal
        showingDeleteConfirmation = true
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Tue, 20 May 2025")
                            .font(.caption)
                            .foregroundStyle(Color.secondary)
                        Spacer()
                        Text("22:24")
                            .font(.caption)
                            .foregroundStyle(Color.secondary)
                    }
                    Text(viewModel.displayedText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.headline)
                        .foregroundStyle(Color.primary)
                        .onAppear {
                            viewModel.startTypingAnimation()
                        }
                        .onDisappear {
                            viewModel.stopTypingAnimation()
                        }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [
                                        Color.accentColor.opacity(0.3),
                                        Color.accentColor.opacity(0.5),
                                    ]
                                ),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                ScrollView {
                    ScrollViewReader { scrollProxy in
                        if viewModel.goals.isEmpty {
                            ContentUnavailableView(
                                "No Goals Yet",
                                systemImage: "target",
                                description: Text("Tap the + button to create your first goal and start getting in the zone!")
                            )
                            .symbolEffect(.pulse, options: .repeating)
                            .padding(.top, 40)
                        } else {
                            ForEach(viewModel.goals) { goal in
                                GoalCard(
                                    goal: goal,
                                    onPlayTapped: {
                                        viewModel.selectedGoal = goal
                                    },
                                    expandedGoalId: viewModel.expandedGoalId,
                                    expandedSection: viewModel.expandedSection,
                                    onSectionToggle: { section in
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                            viewModel.toggleSection(goalId: goal.id, section: section)

                                            // Scroll to the expanded card with animation
                                            if goal.id == viewModel.expandedGoalId {
                                                withAnimation(.easeInOut(duration: 0.3)) {
                                                    scrollProxy.scrollTo(goal.id, anchor: .top)
                                                }
                                            }
                                        }
                                    },
                                    onDeleteTapped: {
                                        // Show confirmation dialog before deleting
                                        withAnimation {
                                            confirmDeleteGoal(goal)
                                        }
                                    }
                                )
                                .id(goal.id)  // Add an ID for the ScrollViewReader
                                .padding(.bottom, 8)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            confirmDeleteGoal(goal)
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationDestination(item: $viewModel.selectedGoal) { goal in
                    TimerView(activeGoal: goal)
                }
                .scrollIndicators(.hidden)
            }
            .padding()
        }
        .navigationTitle("ZØN")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingAddGoal = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .symbolRenderingMode(.hierarchical)
                        .symbolEffect(.bounce, options: .repeating, value: viewModel.goals.isEmpty)
                        .foregroundStyle(Color.accentColor)
                }
                .accessibilityLabel("Add new goal")
            }
        }
        .sheet(isPresented: $showingAddGoal) {
            // This closure runs after the sheet is dismissed
            viewModel.fetchGoals()  // Refresh the goals when returning from AddGoalView
        } content: {
            AddGoalView(modelContext: viewModel.modelContext)
        }
        .alert("Delete Goal", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) {
                goalToDelete = nil
            }
            Button("Delete", role: .destructive) {
                if let goal = goalToDelete {
                    withAnimation {
                        viewModel.deleteGoal(goal)
                    }
                }
                goalToDelete = nil
            }
        } message: {
            Text("Are you sure you want to delete '\(goalToDelete?.name ?? "")'? This action cannot be undone.")
        }
    }
}

#Preview {
    NavigationStack {
        HomeView(modelContext: ModelContext(try! ModelContainer(for: GoalModel.self)))
    }
}
