//
//  HomeViewModel.swift
//  zone
//
//  Created by Zulfikar Noorfan on 23/05/25.
//

import Foundation
import SwiftData

@MainActor
final class HomeViewModel: ObservableObject {
    let modelContext: ModelContext
    @Published var goals: [GoalModel] = []
    @Published var selectedGoal: GoalModel?
    @Published var expandedGoalId: String?
    @Published var expandedSection: ExpandedSection?

    // Text animation properties
    @Published var displayedText = ""
    private let fullText = "Get in the zøne and nail your goals!"
    private var animationTimer: Timer?
    private var isAnimating = false
    private var charIndex = 0
    private var showCursor = true
    private var cursorTimer: Timer?
    private let cursorChar = "_"

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchGoals()
    }

    // Toggle expanded section
    func toggleSection(goalId: String, section: ExpandedSection) {
        // If this goal and section are already expanded, collapse it
        if expandedGoalId == goalId && expandedSection == section {
            expandedGoalId = nil
            expandedSection = nil
        } else {
            // Otherwise, expand this goal and section
            expandedGoalId = goalId
            expandedSection = section
        }
    }

    func fetchGoals() {
        var descriptor = FetchDescriptor<GoalModel>()
        
        // Sort by creation date in descending order (newest first)
        descriptor.sortBy = [SortDescriptor(\GoalModel.createdAt, order: .reverse)]
        
        do {
            goals = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch goals: \(error)")
        }
    }

    func deleteGoal(_ goal: GoalModel) {
        modelContext.delete(goal)

        do {
            try modelContext.save()
            fetchGoals()
        } catch {
            print("Failed to delete goal: \(error)")
        }
    }

    func navigateToTimer(goal: GoalModel) {
        self.selectedGoal = goal
    }

    // MARK: - Text Animation

    func startTypingAnimation() {
        stopTypingAnimation()  // Stop any existing animation
        isAnimating = true
        displayedText = cursorChar
        charIndex = 0
        
        // Create cursor blink timer
        cursorTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            // Dispatch to main actor to safely access properties
            Task { @MainActor [weak self] in
                guard let self = self, self.isAnimating else { return }
                self.showCursor.toggle()
                
                // If we're still typing, always show cursor after the text
                if self.charIndex < self.fullText.count {
                    // Update the last character to be cursor or empty
                    if self.displayedText.isEmpty {
                        self.displayedText = self.cursorChar
                    } else if self.displayedText.last == self.cursorChar.first {
                        self.displayedText.removeLast()
                    } else {
                        self.displayedText.append(self.cursorChar)
                    }
                } else {
                    // When typing is done, just blink the cursor
                    if self.showCursor {
                        if !self.displayedText.hasSuffix(self.cursorChar) {
                            self.displayedText += self.cursorChar
                        }
                    } else {
                        if self.displayedText.hasSuffix(self.cursorChar) {
                            self.displayedText.removeLast()
                        }
                    }
                }
            }
        }
        
        // Create typing timer
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            // Dispatch to main actor to safely access properties
            Task { @MainActor [weak self] in
                guard let self = self, self.isAnimating else { return }
                
                if self.charIndex < self.fullText.count {
                    let index = self.fullText.index(self.fullText.startIndex, offsetBy: self.charIndex)
                    
                    // Remove cursor if present
                    if self.displayedText.hasSuffix(self.cursorChar) {
                        self.displayedText.removeLast()
                    }
                    
                    // Add the next character and cursor
                    self.displayedText += String(self.fullText[index]) 
                    if self.showCursor {
                        self.displayedText += self.cursorChar
                    }
                    
                    self.charIndex += 1
                } else {
                    self.animationTimer?.invalidate()
                    self.animationTimer = nil
                    // Animation is complete, no need to reset
                }
            }
        }
    }

    // Replace the pauseAndReset function with a simplified version that doesn't restart the animation
    private func pauseAndReset() {
        // Keep cursor blinking but stop the typing
        animationTimer?.invalidate()
        animationTimer = nil
        
        // No need to restart the animation as we only want it to run once
    }

    func stopTypingAnimation() {
        isAnimating = false
        animationTimer?.invalidate()
        animationTimer = nil
        cursorTimer?.invalidate()
        cursorTimer = nil
        displayedText = ""
    }
}

enum ExpandedSection {
    case time, todos, progress
}
