//
//  FloatingActionButton.swift
//  zone
//
//  Created by Zulfikar Noorfan on 20/05/25.
//

import SwiftUI

struct FloatingActionButton: View {
    var action: () -> Void
    var icon: String = "plus"
    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: icon)
                .font(.title3.bold())
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(isEnabled ? Color.accentColor : Color.gray.opacity(0.5))
                )
                .shadow(
                    color: isEnabled ? Color.accentColor.opacity(0.3) : Color.gray.opacity(0.1),
                    radius: 10, x: 0, y: 5
                )
                .animation(.easeInOut(duration: 0.2), value: isEnabled)
        }
        .padding()
    }
}

#Preview {
    VStack(spacing: 20) {
        FloatingActionButton(action: {})

        FloatingActionButton(action: {})
            .disabled(true)
    }
}
