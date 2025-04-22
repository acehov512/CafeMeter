import SwiftUI

// MARK: - StrokedText
struct StrokedText: View {
    let text: String
    let size: CGFloat
    let lineWidth: Int
    private let defaultStrokeColor = Color(red: 222/255, green: 162/255, blue: 87/255)
    private let customStrokeColor: Color?
    private let textColor: Color = .white
    private let shadowRadius: CGFloat = 0.5

    init(text: String, size: CGFloat, lineWidth: Int = 2, strokeColor: Color? = nil) {
        self.text = text
        self.size = size
        self.lineWidth = max(1, lineWidth)
        self.customStrokeColor = strokeColor
    }

    var body: some View {
        Text(text)
            .customFont(.customBold, size: size)
            .foregroundColor(textColor)
            .modifier(StackedShadows(
                color: customStrokeColor ?? defaultStrokeColor,
                radius: shadowRadius,
                count: lineWidth
            ))
    }
}

// MARK: - StackedShadows
private struct StackedShadows: ViewModifier {
    let color: Color
    let radius: CGFloat
    let count: Int

    func body(content: Content) -> AnyView {
        applyShadowRecursive(content: content, remaining: count)
    }

    private func applyShadowRecursive(content: Content, remaining: Int) -> AnyView {
        if remaining > 0 {
            return AnyView(
                applyShadowRecursive(content: content, remaining: remaining - 1)
                    .shadow(color: color, radius: radius)
            )
        } else {
            return AnyView(content)
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack(spacing: 20) {
            StrokedText(text: "Font", size: 56, lineWidth: 15)
        }
    }
}
