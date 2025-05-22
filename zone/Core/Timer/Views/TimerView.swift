//
//  TimerView.swift
//  zone
//
//  Created by Zulfikar Noorfan on 20/05/25.
//

import SwiftUI

struct TimerView: View {
    @StateObject var viewModel = TimerViewModel()
    let activeGoal: GoalModel  // Property to receive the goal from HomeView

    var body: some View {
        VStack(spacing: 20) {
            // Goal Card Display using the passed 'activeGoal'
            GoalCard(goal: activeGoal)
                .padding(.horizontal)  // Add some horizontal padding if needed

            // Timer Display
            HStack(spacing: 10) {  // Increased spacing between elements
                // Minutes
                HStack(spacing: 8) {  // Increased spacing between digits
                    FlipView(viewModel: viewModel.flipViewModels[0])
                    FlipView(viewModel: viewModel.flipViewModels[1])
                }
                Text(":")
                    .font(.system(size: 60))  // Increased from 40
                    .fontWeight(.heavy)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 5)  // Added padding around the colon
                // Seconds
                HStack(spacing: 8) {  // Increased spacing between digits
                    FlipView(viewModel: viewModel.flipViewModels[2])
                    FlipView(viewModel: viewModel.flipViewModels[3])
                }
            }
            .scaleEffect(1.3)  // Overall scaling of the timer display
            .padding(.vertical, 20)  // Added vertical padding for more space

            // Controls
            VStack(spacing: 25) {  // Main controls VStack
                // Row 1: Mode Selection & Custom Duration Slider
                VStack(alignment: .center, spacing: 15) {
                    Picker("Timer Mode", selection: $viewModel.timerMode) {
                        Text("Work (\(Int(viewModel.workDuration/60))m)").tag(TimerMode.work)
                        Text("Short Break (\(Int(viewModel.shortBreakDuration/60))m)").tag(
                            TimerMode.shortBreak)
                        Text("Long Break (\(Int(viewModel.longBreakDuration/60))m)").tag(
                            TimerMode.longBreak)
                        Text("Custom").tag(TimerMode.custom)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: viewModel.timerMode) { oldMode, newMode in
                        switch newMode {
                        case .work:
                            viewModel.setTimer(duration: viewModel.workDuration, mode: .work)
                        case .shortBreak:
                            viewModel.setTimer(
                                duration: viewModel.shortBreakDuration, mode: .shortBreak)
                        case .longBreak:
                            viewModel.setTimer(
                                duration: viewModel.longBreakDuration, mode: .longBreak)
                        case .custom:
                            viewModel.setTimer(duration: viewModel.customDuration, mode: .custom)
                        case .idle:
                            viewModel.endSession()
                        }
                    }

                    if viewModel.timerMode == .custom {
                        HStack {
                            Text("\(Int(viewModel.customDuration / 60)) min")
                                .font(.callout)
                                .frame(width: 60, alignment: .leading)
                            Slider(
                                value: $viewModel.customDuration, in: 1 * 60...90 * 60, step: 1 * 60
                            ) {
                                Text("Custom Duration")
                            }
                            .onChange(of: viewModel.customDuration) { oldDuration, newDuration in
                                if viewModel.timerMode == .custom {
                                    viewModel.setTimer(duration: newDuration, mode: .custom)
                                }
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        Text(
                            "\(viewModel.timerMode.displayName): \(Int(viewModel.getCurrentModeDuration() / 60)) min"
                        )
                        .font(.callout)
                        .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)

                // Row 2: Action Buttons
                HStack(spacing: 50) {
                    Button {
                        if viewModel.isActive {
                            viewModel.pauseTimer()
                        } else {
                            viewModel.startTimer()
                        }
                    } label: {
                        Image(systemName: viewModel.isActive ? "pause.fill" : "play.fill")
                            .font(.system(size: 24))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(20)
                    .background(.thinMaterial)
                    .clipShape(Circle())
                    .foregroundColor(Color.accentColor)

                    Button {
                        viewModel.endSession()
                    } label: {
                        Image(systemName: "stop.fill")
                            .font(.system(size: 24))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(20)
                    .background(.thinMaterial)
                    .clipShape(Circle())
                    .foregroundColor(.red)
                }
            }
            .padding(.top, 20)
        }
        .navigationTitle(activeGoal.name)  // Example: Set navigation title based on the goal
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // You might want to configure the viewModel based on the activeGoal here
            // For example, if the goal has a preferred timer duration or mode
        }
    }
}

// Make sure GoalModel is Identifiable and Hashable for NavigationLink(value:)
// If not already, it should look something like this:
// struct GoalModel: Identifiable, Hashable {
//     var id = UUID()
//     let name: String
//     let date: Date
//     let timeSpent: TimeInterval
//     let todosCount: Int
//     let goalPercentage: Double
// }
