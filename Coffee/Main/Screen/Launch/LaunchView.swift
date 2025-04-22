import SwiftUI

// MARK: - Views
struct LaunchView: View {
    @State private var isRotating = false
    var namespace: Namespace.ID
    
    var body: some View {
        VStack {
            ZStack {
                Image("handle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .rotationEffect(Angle(degrees: isRotating ? 390 : 0))
                
                Image("coffee")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.all, 40)
            }
            .matchedGeometryEffect(id: "coffee", in: namespace)
            .overlay(alignment: .bottom) {
                Image("loading")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300)
                    .offset(y: 100)
            }
            .padding(.all, 30)
            .padding(.bottom, 34)
        }
        .frame(maxWidth: .infinity)
        .background(
            Image("launchBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
        )
        .onAppear {
            withAnimation(.linear(duration: 4)) {
                isRotating = true
            }
        }
    }
}

#Preview {
    LaunchView(namespace: Namespace().wrappedValue)
}
