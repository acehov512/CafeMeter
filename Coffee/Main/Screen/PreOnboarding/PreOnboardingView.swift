import SwiftUI

struct PreOnboardingView: View {
    var namespace: Namespace.ID
    @StateObject private var viewModel = PreOnboardingViewModel()
    @EnvironmentObject private var coordinator: MainCoordinator
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.customOrange)
                        .aspectRatio(1.2, contentMode: .fit)
                        .cornerRadius(40)
                        .offset(y: geometry.size.height * 0.22)
                        .padding(.horizontal, 10)
                        .matchedGeometryEffect(id: "orangeRectangle", in: namespace)
                    
                    VStack {
                        Image("cup")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 1)
                            .offset(y: geometry.size.height * 0.1)
                        
                        VStack {
                            Text(viewModel.preOnboardingTitle)
                                .customFont(.customExtraBold, size: 36)
                                .foregroundColor(.white)
                            
                            Text(viewModel.preOnboardingDescription)
                                .customFont(.customRegular, size: 16)
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
                    
                    Button {
                        viewModel.onDeclineButtonTapped()
                    } label: {
                        Text("Thank you, but no")
                            .foregroundColor(Color(red: 209/255, green: 133/255, blue: 39/255))
                            .underline()
                            .customFont(FontName.customRegular, size: 18)
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal, 10)
                .padding(.bottom, geometry.size.height * 0.05)
            }
        }
        .ignoresSafeArea(.all)
        .onAppear {
            viewModel.navigateToOnboarding = { [weak coordinator] in
                coordinator?.navigate(to: .onboarding)
            }
            viewModel.dismissPreOnboarding = { [weak coordinator] in
                coordinator?.navigate(to: .tab)
            }
        }
    }
}

struct PreOnboardingViewPreview: View {
    @Namespace var namespace
    
    var body: some View {
        PreOnboardingView(namespace: namespace)
            .environmentObject(MainCoordinator())
    }
}

#Preview {
    PreOnboardingViewPreview()
}
