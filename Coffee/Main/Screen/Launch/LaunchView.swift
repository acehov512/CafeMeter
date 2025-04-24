import SwiftUI

// MARK: - Views
struct LaunchView: View {
    @State private var rotation = 0.0
    var namespace: Namespace.ID
    
    var body: some View {
        VStack {
            ZStack {
                Image("handle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .rotationEffect(.degrees(rotation))
                
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
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

#Preview {
    LaunchView(namespace: Namespace().wrappedValue)
}
