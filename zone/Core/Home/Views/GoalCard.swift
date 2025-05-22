//
//  GoalCard.swift
//  zone
//
//  Created by Zulfikar Noorfan on 20/05/25.
//

import SwiftUI

struct GoalCard: View {
    let goal: GoalModel
    @State private var isExpandedTime = false
    @State private var isExpandedTodos = false
    @State private var isExpandedProgress = false
    
    
    // Format date to string
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: goal.date)
    }
    
    // Format duration to string
    private var formattedDuration: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: goal.timeSpent) ?? "--"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerView
            infoCardList
            
            // Expanded time spent
            if isExpandedTime {
                expandedTimeView
            }
            
            // Expanded todos
            if isExpandedTodos {
                expandedTodosView
}
            
            // Expanded progress
            if isExpandedProgress {
                expandedProgressView
            }
        }
        .padding(12)
        .background(.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
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
                Image(systemName: "play.circle")
                    .font(.system(.title3, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .background(.accent)
                    .clipShape(Circle())
            }
        }
    }
    
    private var infoCardList: some View {
        HStack(alignment: .center) {
            ExpandedInfoCard(title: "Time Spent") {
                Text(formattedDuration)
            }.onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isExpandedTodos = false
                    isExpandedProgress = false
                    isExpandedTime.toggle()
                }
            }
            
            ExpandedInfoCard(title: "Todos") {
                Text("\(goal.todosCount)")
            }.onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isExpandedTime = false
                    isExpandedProgress = false
                    isExpandedTodos.toggle()
                }
            }
            
            ExpandedInfoCard(title: "Progress") {
                ProgressIndicator(percentage: goal.goalPercentage)
            }.onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isExpandedTime = false
                    isExpandedTodos = false
                    isExpandedProgress.toggle()
                }
            }
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    private var expandedTimeView : some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Time Spent")
                .bold()
                .font(.headline)
            ForEach(0..<6) {index in
                HStack {
                    Text("25 min")
                        .bold()
                    Text("(08:00 - 09:25)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("20 May 2025")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
            }
        }
    }
    
    private var expandedTodosView : some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Todos")
                .bold()
                .font(.headline)
                .padding(.bottom, 4)
            ForEach(0..<6) {index in
                VStack {
                    ListRowView(item: TodoModel(id: "\(index)", goalID: "1", title: "Todo \(index)", isCompleted: true))
                        .onTapGesture {
                            withAnimation(.linear) {
                            }
                        }
                    Divider()
                }
            }
        }
    }
    
    private var expandedProgressView : some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Progress")
                .bold()
                .font(.headline)
                .padding(.bottom, 4)
            VStack(alignment: .leading, spacing: 8) {
                Text("You have completed \(Int(goal.goalPercentage))% of your goals.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 8)
                CircularProgress(percentage: goal.goalPercentage, lineWidth: nil)
                    .frame(width: 50, height: 50, alignment: .center)
            }
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
            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 4, y:4)
            .cornerRadius(10)
        }
    }
    
    struct ListRowView: View {
        let item: TodoModel
        
        var body: some View {
            HStack {
                Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                    .foregroundColor(item.isCompleted ? .green : .red)
                Text(item.title)
                    .font(.headline)
                Spacer()
            }
            .font(.title)
            .padding(.vertical, 8)
        }
    }
}

// MARK: - Previews
#Preview {
    VStack(spacing: 16) {
        GoalCard(goal: GoalModel(
            name: "Goal 1",
            date: Date(),
            timeSpent: 3600,
            todosCount: 12,
            goalPercentage: 25
        ))
        
        GoalCard(goal: GoalModel(
            name: "Goal 2",
            date: Date(),
            timeSpent: 2100,
            todosCount: 6,
            goalPercentage: 50
        ))
        
        
        
        GoalCard(goal: GoalModel(
            name: "Goal 3",
            date: Date(),
            timeSpent: 2100,
            todosCount: 6,
            goalPercentage: 75
        ))
        
        
        
        GoalCard(goal: GoalModel(
            name: "Goal 4",
            date: Date(),
            timeSpent: 2100,
            todosCount: 6,
            goalPercentage: 100
        ))
    }
    .padding(.horizontal)
}
