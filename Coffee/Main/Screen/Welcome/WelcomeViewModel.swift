import SwiftUI
import Combine

// MARK: - WelcomeViewModel
final class WelcomeViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var welcomeTitle = "Welcome to app"
    @Published var welcomeDescription = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
    
    // MARK: - Callbacks
    var navigateToAuth: (() -> Void)?
    
    // MARK: - Actions
    func onStartButtonTapped() {
        navigateToAuth?()
    }
} 
