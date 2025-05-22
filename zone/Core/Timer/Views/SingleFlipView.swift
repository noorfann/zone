//
//  SingleFlipView.swift
//  zone
//
//  Created by Zulfikar Noorfan on 21/05/25.
//

import SwiftUI

struct SingleFlipView: View {

    init(text: String, type: FlipType) {
        self.text = text
        self.type = type
    }

    var body: some View {
        Text(text)
            .font(.system(size: 40))
            .fontWeight(.heavy)
            .foregroundColor(.white)
            .fixedSize()
            .padding(type.padding, -20)
            .frame(width: 15, height: 20, alignment: type.alignment)
            .padding(type.paddingEdges, 10)
            .clipped()
            .background(.black)
            .cornerRadius(4)
            .padding(type.padding, -4.5)
            .clipped()
    }

    enum FlipType {
        case top
        case bottom

        var padding: Edge.Set {
            switch self {
            case .top:
                return .bottom
            case .bottom:
                return .top
            }
        }

        var paddingEdges: Edge.Set {
            switch self {
            case .top:
                return [.top, .leading, .trailing]
            case .bottom:
                return [.bottom, .leading, .trailing]
            }
        }

        var alignment: Alignment {
            switch self {
            case .top:
                return .bottom
            case .bottom:
                return .top
            }
        }

    }

    // MARK: - Private
    private let text: String
    private let type: FlipType

}

#Preview {
    SingleFlipView(text: "12", type: .top)
}
