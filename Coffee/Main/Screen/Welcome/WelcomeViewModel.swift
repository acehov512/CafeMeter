import SwiftUI
import Combine

// MARK: - WelcomeViewModel
final class WelcomeViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var welcomeTitle = "Welcome to app"
    @Published var welcomeDescription = "Track your caffeine, organize your coffee shelf, and explore personalized brews. Smarter coffee starts here. Let the journey begin!"
    
    // MARK: - Callbacks
    var navigateToAuth: (() -> Void)?
    
    // MARK: - Actions
    func onStartButtonTapped() {
        navigateToAuth?()
    }
} 
