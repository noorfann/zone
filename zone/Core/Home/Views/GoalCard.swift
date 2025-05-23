//
//  GoalCard.swift
//  zone
//
//  Created by Zulfikar Noorfan on 20/05/25.
//

import Foundation
import SwiftData
import SwiftUI

// MARK: - Constants
private enum AnimationConstants {
    static let springResponse = 0.3
    static let springDamping = 0.8
    static let progressDuration = 1.5
}

struct GoalCard: View {
    let goal: GoalModel
    let onPlayTapped: () -> Void
    let expandedGoalId: String?
    let expandedSection: ExpandedSection?
    let onSectionToggle: (ExpandedSection) -> Void
    let onDeleteTapped: () -> Void  // Add this line

    @State private var animateProgress = false

    // Helper computed properties to check which section is expanded
    private var isExpandedTime: Bool {
        expandedGoalId == goal.id && expandedSection == .time
    }

    private var isExpandedTodos: Bool {
        expandedGoalId == goal.id && expandedSection == .todos
    }

    private var isExpandedProgress: Bool {
        expandedGoalId == goal.id && expandedSection == .progress
    }

    // Format date to string
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: goal.createdAt)
    }

    // Format duration to string
    private var formattedDuration: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: goal.timeSpent) ?? "--"
    }

    // Format time for logs
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerView
            infoCardList

            // Use ViewBuilder for expandable content
            expandableContentView
        }
        .padding(12)
        .background(.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    @ViewBuilder
    private var expandableContentView: some View {
        if isExpandedTime {
            expandedTimeView
        } else if isExpandedTodos {
            expandedTodosView
        } else if isExpandedProgress {
            expandedProgressView
        }
    }
}

// MARK: - Subviews
extension GoalCard {
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(formattedDate)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text("🎯 \(goal.name)")
                    .font(.title3)
                    .fontWeight(.semibold)
            }

            Spacer()

            HStack(spacing: 8) {
                Button {
                    onPlayTapped()  // Call the callback when play button tapped
                } label: {
                    Image(systemName: "play.circle")
                        .font(.system(.title3, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 36, height: 36)
                        .background(.accent)
                        .clipShape(Circle())
                }

                Menu {
                    Button(role: .destructive, action: onDeleteTapped) {
                        Label("Delete Goal", systemImage: "trash")
                    }
                    // Add other options here as needed
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title2)
                        .foregroundStyle(Color.secondary)
                }
            }
        }
    }

    private var infoCardList: some View {
        HStack(alignment: .center) {
            ExpandedInfoCard(title: "Time Spent") {
                Text(formattedDuration)
            }.onTapGesture {
                onSectionToggle(.time)
            }

            ExpandedInfoCard(title: "Todos") {
                Text("\(goal.todosCount)")
            }.onTapGesture {
                onSectionToggle(.todos)
            }

            ExpandedInfoCard(title: "Progress") {
                ProgressIndicator(percentage: goal.goalPercentage)
            }.onTapGesture {
                onSectionToggle(.progress)
            }
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    private var expandedTimeView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Time Spent")
                .bold()
                .font(.headline)
            if !goal.timeLogs.isEmpty {
                ForEach(goal.timeLogs) { log in
                    HStack {
                        // Format duration in minutes
                        Text("\(Int(log.duration / 60)) min")
                            .bold()

                        // Format start and end times
                        Text("(\(formattedTime(log.startTime)) - \(formattedTime(log.endTime)))")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Spacer()

                        Text(log.startTime.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                }
            } else {
                Text("No time logs yet")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding()
            }
        }
    }

    private var expandedTodosView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Todos")
                .bold()
                .font(.headline)
                .padding(.bottom, 4)
            ForEach(goal.todos) { todo in
                VStack {
                    TodoListRowView(item: todo)
                    Divider()
                }
            }
            if goal.todos.isEmpty {
                Text("No todos yet")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding()
            }
        }
    }

    private var expandedProgressView: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("Progress")
                .bold()
                .font(.headline)
                .padding(.bottom, 4)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("You have completed \(Int(goal.goalPercentage))% of your todos.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.bottom, 8)
                .frame(maxWidth: .infinity, alignment: .center)

            CircularProgress(
                percentage: animateProgress ? goal.goalPercentage : 0,
                lineWidth: nil,
                animationDuration: AnimationConstants.progressDuration
            )
            .frame(width: 100, height: 100, alignment: .center)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .onAppear {
            // Start with 0% and animate to the actual percentage
            animateProgress = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: AnimationConstants.progressDuration)) {
                    animateProgress = true
                }
            }
        }
        .onDisappear {
            // Reset when disappearing
            animateProgress = false
        }
    }
}

// MARK: - Extensions
extension GoalCard {
    struct ExpandedInfoCard<Content: View>: View {
        let title: String
        let content: Content

        init(title: String, @ViewBuilder content: () -> Content) {
            self.title = title
            self.content = content()
        }

        var body: some View {
            VStack {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                content
                    .font(.callout)
                    .fontWeight(.medium)
                    .frame(height: 12)
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(.background)
            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 4, y: 4)
            .cornerRadius(10)
        }
    }
}

#Preview {
    NavigationStack {
        let goal = GoalModel(name: "Sample Goal", createdAt: .now)


        VStack(spacing: 20) {
            // Preview with time section expanded
            GoalCard(
                goal: goal,
                onPlayTapped: {},
                expandedGoalId: goal.id,
                expandedSection: .time,
                onSectionToggle: { _ in }, onDeleteTapped: {}
            )

            // Preview with todos section expanded
            GoalCard(
                goal: goal,
                onPlayTapped: {},
                expandedGoalId: goal.id,
                expandedSection: .todos,
                onSectionToggle: { _ in }, onDeleteTapped: {}
            )

            // Preview with progress section expanded
            GoalCard(
                goal: goal,
                onPlayTapped: {},
                expandedGoalId: goal.id,
                expandedSection: .progress,
                onSectionToggle: { _ in }, onDeleteTapped: {}
            )

            // Preview with no expansion
            GoalCard(
                goal: goal,
                onPlayTapped: {},
                expandedGoalId: nil,
                expandedSection: nil,
                onSectionToggle: { _ in },
                onDeleteTapped: {}
            )
        }
        .padding()
    }
}
