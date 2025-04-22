import SwiftUI
import Combine

class PostOnboardingViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var postOnboardingTitle = "Thank you for your answers"
    
    // MARK: - Callbacks
    var navigateToOnboarding: (() -> Void)?
    var navigateToHomeScreen: (() -> Void)?
    var dismissPreOnboarding: (() -> Void)?
    
    // MARK: - Actions
    func onStartButtonTapped() {
        print("LET`S START")
        navigateToHomeScreen?()
    }
} 
