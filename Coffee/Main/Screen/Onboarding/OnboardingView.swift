import SwiftUI

struct OnboardingView: View {
    var namespace: Namespace.ID
    @StateObject private var viewModel = OnboardingViewModel()
    @EnvironmentObject private var coordinator: MainCoordinator
    
    private let questionBgColor = Color(red: 235/255, green: 160/255, blue: 66/255, opacity: 1)
    private let selectedOptionBgColor = Color(red: 235/255, green: 160/255, blue: 66/255, opacity: 1)
    private let optionTextColor = Color(red: 249/255, green: 197/255, blue: 133/255)
    private let optionBorderColor = Color(red: 228/255, green: 167/255, blue: 91/255)
    private let optionHeight: CGFloat = 60
    
    var body: some View {
        VStack {
            VStack(spacing: 15) {
                Text(viewModel.currentQuestion.title)
                    .foregroundColor(.white)
                    .customFont(.customExtraBold, size: 28)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
                if viewModel.showAllergens {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(Array(viewModel.allergens.enumerated()), id: \.element.id) { index, allergen in
                                allergenButton(index: index, allergen: allergen)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxHeight: 300)
                } else {
                    ForEach(Array(viewModel.currentQuestion.options.enumerated()), id: \.offset) { index, option in
                        optionButton(index: index, title: option)
                    }
                }
            }
            .padding(.vertical, 30)
            .padding(.horizontal, 10)
            .background(
                questionBgColor
                    .cornerRadius(40)
                    .matchedGeometryEffect(id: "orangeRectangle", in: namespace)
            )
            .padding(.horizontal, 10)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.currentQuestionIndex)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.showAllergens)
            
            Spacer()
            
            HStack(spacing: 10) {
                CustomButton(text: "←", style: .orange) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        viewModel.previousQuestion()
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.3)
                .disabled(!viewModel.canGoBack)
                .opacity(viewModel.canGoBack ? 1.0 : 0.5)
                
                CustomButton(text: "NEXT", style: .red) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        viewModel.nextQuestion()
                    }
                }
                .matchedGeometryEffect(id: "actionButton", in: namespace)
                .frame(width: UIScreen.main.bounds.width * 0.6)
                .disabled(!viewModel.canGoForward)
                .opacity(viewModel.canGoForward ? 1.0 : 0.5)
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 20)
        }
        .onAppear {
            viewModel.navigateToNextScreen = { [weak coordinator] in
                withAnimation {
                    coordinator?.navigate(to: .postOnboarding)
                }
            }
        }
    }
    
    private func optionButton(index: Int, title: String) -> some View {
        let isSelected = viewModel.selectedOptions[viewModel.currentQuestionIndex] == index
        
        return Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                viewModel.selectOption(at: index)
            }
        }) {
            Text(title)
                .customFont(isSelected ? .customBold : .customRegular, size: 24)
                .foregroundColor(isSelected ? .white : optionTextColor)
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: optionHeight)
                .background(
                    RoundedRectangle(cornerRadius: optionHeight / 2)
                        .fill(isSelected ? selectedOptionBgColor : Color.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: optionHeight / 2)
                        .stroke(isSelected ? Color.white : optionBorderColor, lineWidth: 2)
                )
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 20)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .id("\(viewModel.currentQuestionIndex)-\(index)")
    }
    
    private func allergenButton(index: Int, allergen: AllergenItem) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                viewModel.toggleAllergen(at: index)
            }
        }) {
            HStack {
                Text(allergen.name)
                    .customFont(allergen.isSelected ? .customBold : .customRegular, size: 18)
                    .foregroundColor(allergen.isSelected ? .white : optionTextColor)
                
                Spacer()
                
                if allergen.isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: optionHeight)
            .background(
                RoundedRectangle(cornerRadius: optionHeight / 2)
                    .fill(allergen.isSelected ? selectedOptionBgColor : Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: optionHeight / 2)
                    .stroke(allergen.isSelected ? Color.white : optionBorderColor, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: allergen.isSelected)
    }
}

#Preview {
    OnboardingViewPreview()
}

struct OnboardingViewPreview: View {
    @Namespace var namespace
    
    var body: some View {
        OnboardingView(namespace: namespace)
            .environmentObject(MainCoordinator())
    }
} 
