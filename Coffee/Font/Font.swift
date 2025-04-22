import SwiftUI

enum FontName: String {
    case customExtraBold = "Rubik-ExtraBold"
    case customBold = "Rubik-Bold"
    case customRegular = "Rubik-Regular"
    case customBlack = "Rubik-Black"
    
    func size(_ size: CGFloat) -> Font {
        return .custom(self.rawValue, size: size)
    }
}

extension Font {
    static func customFont(_ style: FontName, size: CGFloat) -> Font {
        return style.size(size)
    }
}

extension View {
    func customFont(_ style: FontName, size: CGFloat) -> some View {
        self.font(.customFont(style, size: size))
    }
}


