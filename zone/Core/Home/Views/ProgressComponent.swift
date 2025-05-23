//
//  CircularProgress.swift
//  zone
//
//  Created by Zulfikar Noorfan on 20/05/25.
//

import SwiftUI

struct ProgressIndicator: View {
    let percentage: Double
    private let pillCount = 4
    
    private var activePills: Int {
        Int(ceil(percentage / 25.0))
    }
    
    private func pillColor(_ index: Int) -> Color {
        if index >= activePills {
            return .gray.opacity(0.3)
        }
        
        switch index {
        case 0: return .red
        case 1: return .orange
        case 2: return .yellow
        case 3: return .green
        default: return .gray.opacity(0.3)
        }
    }
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<pillCount, id: \.self) { index in
                Capsule()
                    .fill(pillColor(index))
                    .frame(width: 16, height: 6)
            }
        }
    }
}


struct CircularProgress: View {
    let percentage: Double
    let lineWidth: CGFloat?
    var animationDuration: Double = 1.0  // Default duration
    
    private var strokeColor: Color {
        let index = Int(ceil(percentage / 25.0))
        switch index {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .green
        default: return .gray.opacity(0.3)
        }
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    strokeColor.opacity(0.5),
                    lineWidth: lineWidth ?? 10
                )
            Circle()
                .trim(from: 0, to: percentage / 100)
                .stroke(
                    strokeColor,
                    style: StrokeStyle(
                        lineWidth: lineWidth ?? 10,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: animationDuration), value: percentage)  // Use the custom duration
        }
    }
}

#Preview {
    Group {
        VStack(spacing: 10) {
            ProgressIndicator(percentage: 25)
            CircularProgress(percentage: 25, lineWidth: 5)
                .frame(width: 30, height: 30)
        }
        VStack(spacing: 10) {
            ProgressIndicator(percentage: 50)
            CircularProgress(percentage: 50, lineWidth: 5)
                .frame(width: 30, height: 30)
        }
        VStack(spacing: 10) {
            ProgressIndicator(percentage: 75)
            CircularProgress(percentage: 75, lineWidth: 5)
                .frame(width: 30, height: 30)
        }
        VStack(spacing: 10) {
            ProgressIndicator(percentage: 100)
            CircularProgress(percentage: 100, lineWidth: 5)
                .frame(width: 30, height: 30)
        }
        
    }
}
