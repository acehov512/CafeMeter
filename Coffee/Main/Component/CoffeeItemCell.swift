import SwiftUI

struct CoffeeItemCell: View {
    let title: String
    var isSelected: Bool = false
    var onTap: () -> Void = {}
    
    private let backgroundColor = Color(red: 255/255, green: 212/255, blue: 137/255)
    private let strokeColor = Color.white
    private let strokeWidth: CGFloat = 2
    private let cornerRadius: CGFloat = 6
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                StrokedText(text: title, size: 32)
                    .padding(.vertical, 8)
                
                Spacer()
                
                checkmarkView
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(backgroundColor)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var checkmarkView: some View {
        ZStack {
            Rectangle()
                .fill(Color.white.opacity(0.01))
                .frame(width: 44, height: 44)
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(strokeColor, lineWidth: strokeWidth)
                )
            
            if isSelected {
                Image(systemName: "checkmark")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    VStack(spacing: 4) {
        CoffeeItemCell(title: "Arabica", isSelected: true)
        CoffeeItemCell(title: "Robusta", isSelected: false)
        CoffeeItemCell(title: "Colombia", isSelected: false)
    }
}
