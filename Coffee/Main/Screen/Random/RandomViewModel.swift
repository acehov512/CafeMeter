import SwiftUI
import Combine

// MARK: - Random ViewModel
class RandomViewModel: ObservableObject {
    @Published var selectedCoffeeType: CoffeeType?
    @Published var showResult = false
    @Published var showRecipe = false
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    init() {
        generateRandomCoffee()
        
        setupSubscriptions()
    }
    
    // MARK: - Methods
    func generateRandomCoffee() {
        selectedCoffeeType = CoffeeType.allCases.randomElement()
    }
    
    private func setupSubscriptions() {
        NotificationCenter.default.publisher(for: RecipeViewModel.drinkConsumedNotification)
            .sink { [weak self] _ in
                self?.resetAndGenerateNewCoffee()
            }
            .store(in: &cancellables)
    }
    
    private func resetAndGenerateNewCoffee() {
        showRecipe = false
        showResult = false
        
        generateRandomCoffee()
    }
} 
