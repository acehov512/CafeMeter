import SwiftUI

// MARK: - Views
struct WelcomeView: View {
    var namespace: Namespace.ID
    @StateObject private var viewModel = WelcomeViewModel()
    @EnvironmentObject private var coordinator: MainCoordinator
    
    @State private var rectangleAppeared = false
    @State private var textsAppeared = false
    @State private var buttonAppeared = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                mainContent(geometry)
                Spacer()
                startButton(geometry)
            }
            .onAppear(perform: setupView)
        }
        .ignoresSafeArea(.all)
    }
    
    private func mainContent(_ geometry: GeometryProxy) -> some View {
        ZStack {
            Rectangle()
                .fill(Color.customOrange)
                .aspectRatio(1.3, contentMode: .fit)
                .cornerRadius(40)
                .offset(y: geometry.size.height * 0.22)
                .padding(.horizontal, 10)
                .opacity(rectangleAppeared ? 1 : 0)
                .scaleEffect(rectangleAppeared ? 1 : 0.8)
                .matchedGeometryEffect(id: "orangeRectangle", in: namespace)
            
            VStack {
                Image("cup")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width)
                    .offset(y: geometry.size.height * 0.07)
                    .matchedGeometryEffect(id: "coffee", in: namespace)
                
                welcomeText
                    .multilineTextAlignment(.center)
                    .offset(y: geometry.size.height * 0.05)
                    .padding(.horizontal, 30)
                    .opacity(textsAppeared ? 1 : 0)
            }
        }
        .frame(height: geometry.size.height * 0.7)
    }
    
    private var welcomeText: some View {
        VStack {
            Text(viewModel.welcomeTitle)
                .customFont(.customExtraBold, size: 36)
                .foregroundColor(.white)
            
            Text(viewModel.welcomeDescription)
                .customFont(.customRegular, size: 16)
                .foregroundColor(.white)
        }
    }
    
    private func startButton(_ geometry: GeometryProxy) -> some View {
        CustomButton(text: "START", style: .red) {
            viewModel.onStartButtonTapped()
        }
        .padding(.horizontal, 10)
        .padding(.bottom, geometry.size.height * 0.05)
        .opacity(buttonAppeared ? 1 : 0)
        .matchedGeometryEffect(id: "actionButton", in: namespace)
    }
    
    private func setupView() {
        viewModel.navigateToAuth = { [weak coordinator] in
            withAnimation {
                coordinator?.navigate(to: .auth)
            }
        }
        
        withAnimation(.easeInOut(duration: 0.7)) {
            rectangleAppeared = true
        }
        
        withAnimation(.easeInOut(duration: 0.7).delay(0.3)) {
            textsAppeared = true
        }
        
        withAnimation(.easeInOut(duration: 0.7).delay(0.6)) {
            buttonAppeared = true
        }
    }
}

#Preview {
    WelcomeView(namespace: Namespace().wrappedValue)
        .environmentObject(MainCoordinator())
}
