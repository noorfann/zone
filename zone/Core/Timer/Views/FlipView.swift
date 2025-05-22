//
//  FlipView.swift
//  zone
//
//  Created by Zulfikar Noorfan on 21/05/25.
//

import SwiftUI

struct FlipView: View {

    init(viewModel: FlipViewModel) {
        self.viewModel = viewModel
    }

    @ObservedObject var viewModel: FlipViewModel

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                SingleFlipView(text: viewModel.newValue ?? "", type: .top)
                SingleFlipView(text: viewModel.oldValue ?? "", type: .top)
                    .rotation3DEffect(
                        .init(degrees: viewModel.animateTop ? -89.9 : 0.0),  // Avoid exactly -90
                        axis: (x: 1, y: 0, z: 0),
                        anchor: .bottom,
                        perspective: 0.005)  // Reduced perspective
            }
            Color.black
                .frame(height: 1)
            ZStack {
                SingleFlipView(text: viewModel.oldValue ?? "", type: .bottom)
                SingleFlipView(text: viewModel.newValue ?? "", type: .bottom)
                    .rotation3DEffect(
                        .init(degrees: viewModel.animateBottom ? 0.0 : 89.9),  // Avoid exactly 90
                        axis: (x: 1, y: 0, z: 0),
                        anchor: .top,
                        perspective: 0.005)  // Reduced perspective
            }
        }
        .fixedSize()
    }

}

#Preview {
    FlipView(viewModel: FlipViewModel())
}
