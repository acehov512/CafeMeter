import SwiftUI

// MARK: - Models
enum ButtonStyle {
    case orange
    case red
    
    var backgroundColor: Color {
        switch self {
        case .orange:
            return Color(red: 235/255, green: 160/255, blue: 66/255, opacity: 1)
        case .red:
            return Color(red: 255/255, green: 61/255, blue: 61/255, opacity: 1)
        }
    }
}

// MARK: - Views
struct CustomButton: View {
    let text: String
    let style: ButtonStyle
    let height: CGFloat
    let action: () -> Void
    
    private let bottomLayerColor = Color(red: 218/255, green: 206/255, blue: 206/255, opacity: 1)
    private let topLayerVerticalOffset: CGFloat = -5
    private let strokeWidth: CGFloat = 3
    private let fontSize: CGFloat = 32
    
    init(text: String, style: ButtonStyle, height: CGFloat = 70, action: @escaping () -> Void) {
        self.text = text
        self.style = style
        self.height = height
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Capsule()
                    .fill(bottomLayerColor)
                
                Capsule()
                    .fill(style.backgroundColor)
                    .overlay(
                        Capsule()
                            .stroke(Color.white, lineWidth: strokeWidth)
                    )
                    .offset(y: topLayerVerticalOffset)
                
                buttonContent
            }
            .frame(height: height)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    @ViewBuilder
    private var buttonContent: some View {
        if text == "←" {
            Image(systemName: "arrow.left")
                .font(.system(size: fontSize * 1.5 * (height / 70), weight: .semibold))
                .foregroundColor(.white)
                .offset(y: topLayerVerticalOffset)
        } else {
            Text(text)
                .customFont(.customBold, size: fontSize * (height / 70))
                .foregroundColor(.white)
                .offset(y: topLayerVerticalOffset)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        CustomButton(text: "START", style: .orange) {}
            .padding(.horizontal)
        
        CustomButton(text: "←", style: .orange, height: 60) {}
            .padding(.horizontal)
            .frame(width: 120)
        
        CustomButton(text: "START", style: .red) {}
            .padding(.horizontal)
    }
}
