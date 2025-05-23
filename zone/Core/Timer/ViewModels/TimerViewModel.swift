//
//  ClockViewModel.swift
//  zone
//
//  Created by Zulfikar Noorfan on 21/05/25.
//

import Combine
import Foundation
import SwiftUI

class TimerViewModel: ObservableObject {

    @Published var remainingTime: TimeInterval = 0
    @Published var timerMode: TimerMode = .work  // Default to work
    @Published var isActive: Bool = false
    @Published var customDuration: TimeInterval = 10 * 60  // Default custom duration

    // Durations in seconds
    var workDuration: TimeInterval = 25 * 60
    var shortBreakDuration: TimeInterval = 5 * 60
    var longBreakDuration: TimeInterval = 15 * 60
    // var customDuration: TimeInterval = 10 * 60 // Moved to @Published

    private var currentSessionStartTime: Date?
    private var timer: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()

    private(set) lazy var flipViewModels = { (0...3).map { _ in FlipViewModel() } }()

    init() {
        // Initial setup, default to work session by calling setTimer
        setTimer(duration: workDuration, mode: .work)
    }

    func setTimer(duration: TimeInterval, mode: TimerMode) {
        self.remainingTime = duration
        self.timerMode = mode
        self.isActive = false
        self.timer?.cancel()
        updateFlipViewModels(time: remainingTime)
    }

    func startTimer() {
        guard !isActive else { return }
        isActive = true
        currentSessionStartTime = Date()

        // If remainingTime is 0, reset to the mode's duration
        if remainingTime <= 0 {
            switch timerMode {
            case .work:
                remainingTime = workDuration
            case .shortBreak:
                remainingTime = shortBreakDuration
            case .longBreak:
                remainingTime = longBreakDuration
            case .custom:
                remainingTime = customDuration  // Ensure customDuration is set before starting
            case .idle:
                return  // Do nothing if idle
            }
        }

        updateFlipViewModels(time: remainingTime)

        timer = Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, self.isActive else { return }
                if self.remainingTime > 0 {
                    self.remainingTime -= 1
                    self.updateFlipViewModels(time: self.remainingTime)
                } else {
                    self.pauseTimer()  // Or handle session completion
                    // TODO: Implement logic for what happens when timer finishes (e.g., switch to break)
                }
            }
    }

    func pauseTimer() {
        isActive = false
        timer?.cancel()
    }

    func resetTimer() {
        isActive = false
        timer?.cancel()
        // Reset to the current mode's default duration
        switch timerMode {
        case .work:
            remainingTime = workDuration
        case .shortBreak:
            remainingTime = shortBreakDuration
        case .longBreak:
            remainingTime = longBreakDuration
        case .custom:
            remainingTime = customDuration  // Or a default custom duration
        case .idle:
            remainingTime = 0
        }
        updateFlipViewModels(time: remainingTime)
    }

    func endSession() {
        pauseTimer()
        // Potentially log session, reset to idle, etc.
        timerMode = .idle
        remainingTime = 0
        updateFlipViewModels(time: remainingTime)
        // Add any other logic for ending a session, like preparing for the next one or going to an idle state.
    }

    private func updateFlipViewModels(time: TimeInterval) {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60

        let timeString = String(format: "%02d%02d", minutes, seconds)

        zip(timeString, flipViewModels).forEach { digitChar, viewModel in
            viewModel.text = "\(digitChar)"
        }
    }

    func getCurrentModeDuration() -> TimeInterval {
        switch timerMode {
        case .work:
            return workDuration
        case .shortBreak:
            return shortBreakDuration
        case .longBreak:
            return longBreakDuration
        case .custom:
            return customDuration
        case .idle:
            return 0
        }
    }
}
