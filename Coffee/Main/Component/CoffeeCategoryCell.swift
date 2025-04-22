import SwiftUI

struct CoffeeCategoryCell: View {
    let title: String
    let subtitle: String
    var image: Image?
    var onTap: () -> Void = {}
    
    private let backgroundColor = Color(red: 245/255, green: 218/255, blue: 146/255)
    private let textColor = Color(red: 152/255, green: 107/255, blue: 51/255)
    private let cornerRadius: CGFloat = 12
    private let imageSize: CGFloat = 98
    
    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .center, spacing: 10) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .customFont(.customBold, size: 24)
                        .foregroundColor(textColor)
                    
                    Spacer()
                    
                    Text(subtitle)
                        .customFont(.customRegular, size: 24)
                        .foregroundColor(textColor)
                    
                }
                .padding(.leading, 10)
                .padding(.vertical, 10)
                Spacer()
                
                if let image = image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageSize, height: imageSize)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                } else {
                    Rectangle()
                        .fill(Color(red: 155/255, green: 155/255, blue: 155/255)) 
                        .frame(width: imageSize, height: imageSize)
                        .cornerRadius(cornerRadius)
                }
            }
            .frame(height: imageSize)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

extension CoffeeCategoryCell {
    init(title: String, subtitle: String, image: Image, onTap: @escaping () -> Void = {}) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.onTap = onTap
    }
}

#Preview {
    VStack(spacing: 10) {
        CoffeeCategoryCell(title: "Cappuccino", subtitle: "350 ml")
        
        CoffeeCategoryCell(
            title: "Latte", 
            subtitle: "400 ml", 
            image: Image(systemName: "cup.and.saucer.fill")
        )
        
        CoffeeCategoryCell(title: "Espresso", subtitle: "50 ml")
    }
    .padding()
} 
