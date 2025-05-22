//
//  HomeView.swift
//  zone
//
//  Created by Zulfikar Noorfan on 20/05/25.
//

import SwiftUI

struct HomeView: View {
    let goals: [GoalModel] = [
        GoalModel(name: "Goal 1", date: .now, timeSpent: 3600, todosCount: 10, goalPercentage: 25),
        GoalModel(name: "Goal 2", date: .now, timeSpent: 3600, todosCount: 10, goalPercentage: 50),
        GoalModel(name: "Goal 3", date: .now, timeSpent: 3600, todosCount: 10, goalPercentage: 75),
        GoalModel(name: "Goal 4", date: .now, timeSpent: 3600, todosCount: 10, goalPercentage: 100),
    ]

    var body: some View {
        // Remove NavigationStack from here
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 10) {
                HStack(alignment: .top) {
                    Text("Get in the zøne and nail your goals!")
                        .padding(.trailing)
                        .font(.headline)
                        .foregroundStyle(Color.primary)
                    Spacer()
                    VStack(alignment: .trailing, spacing: 10) {
                        Text("Tue, 20 May 2025")
                            .font(.caption)
                            .foregroundStyle(Color.secondary)
                        Text("22:24")
                            .font(.caption)
                            .foregroundStyle(Color.secondary)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.accentColor.opacity(0.4))
                )
                ScrollView {
                    ForEach(goals) { goal in
                        NavigationLink(value: goal) {  // Pass the goal as a value
                            GoalCard(goal: goal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .navigationDestination(for: GoalModel.self) { goalValue in  // This remains here
                    TimerView(activeGoal: goalValue)
                }
                .scrollIndicators(.hidden)
            }
            .padding()

            // floatingActionButton
            //                FloatingActionButton(action: {
            //                }, icon: "play.fill")
        }
        .navigationTitle("ZØN") // This should now work as HomeView is the root of the NavStack
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {

                } label: {
                    Text("Add")
                }
            }
        }
    }
}

#Preview {
    // For the preview, you'd still want a NavigationStack or NavigationView
    // to see the title and toolbar correctly.
    NavigationStack {
        HomeView()
    }
}
