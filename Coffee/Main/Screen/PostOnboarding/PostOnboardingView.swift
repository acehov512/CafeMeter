import SwiftUI

struct PostOnboardingView: View {
    var namespace: Namespace.ID
    @StateObject private var viewModel = PostOnboardingViewModel()
    @EnvironmentObject private var coordinator: MainCoordinator
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.customOrange)
                        .aspectRatio(2, contentMode: .fit)
                        .cornerRadius(40)
                        .offset(y: geometry.size.height * 0.24)
                        .padding(.horizontal, 10)
                        .matchedGeometryEffect(id: "orangeRectangle", in: namespace)
                    
                    VStack {
                        Image("cup")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 1)
                            .offset(y: geometry.size.height * 0.07)
                        
                        VStack {
                            Text(viewModel.postOnboardingTitle)
                                .customFont(.customExtraBold, size: 36)
                                .foregroundColor(.white)
                        }
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .offset(y: geometry.size.height * 0.05)
                    }
                }
                .frame(height: geometry.size.height * 0.7)
                
                Spacer()
                
                VStack {
                    CustomButton(text: "LET'S GO", style: .red) {
                        viewModel.onStartButtonTapped()
                    }
                    .matchedGeometryEffect(id: "actionButton", in: namespace)
                }
                .padding(.horizontal, 10)
                .padding(.bottom, geometry.size.height * 0.05)
            }
        }
        .ignoresSafeArea(.all)
        .onAppear {
            viewModel.navigateToHomeScreen = { [weak coordinator] in
                coordinator?.navigate(to: .tab)
            }
        }
    }
}

struct PostOnboardingViewPreview: View {
    @Namespace var namespace
    
    var body: some View {
        PostOnboardingView(namespace: namespace)
            .environmentObject(MainCoordinator())
    }
}

#Preview {
    PostOnboardingViewPreview()
}
