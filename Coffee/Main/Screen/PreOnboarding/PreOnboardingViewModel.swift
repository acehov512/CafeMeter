import SwiftUI
import Combine

class PreOnboardingViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var preOnboardingTitle = "Help us learn more about your tastes"
    @Published var preOnboardingDescription = "Tell us what you like so we can craft brews just for you. The more we know, the better your coffee experience."
    
    // MARK: - Callbacks
    var navigateToOnboarding: (() -> Void)?
    var dismissPreOnboarding: (() -> Void)?
    
    // MARK: - Actions
    func onStartButtonTapped() {
        print("LET`S GO")
        navigateToOnboarding?()
    }
    
    func onDeclineButtonTapped() {
        print("Thank you, but no")
        dismissPreOnboarding?()
    }
} 
