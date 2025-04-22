import SwiftUI
import Combine

class PreOnboardingViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var preOnboardingTitle = "Help us learn more about your tastes"
    @Published var preOnboardingDescription = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
    
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
