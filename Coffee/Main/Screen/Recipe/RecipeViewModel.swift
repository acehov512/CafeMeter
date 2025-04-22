import SwiftUI
import Combine

// MARK: - Recipe ViewModel
class RecipeViewModel: ObservableObject {
    static let drinkConsumedNotification = Notification.Name("DrinkConsumedNotification")
    
    func saveRecipe() {
    }
    
    func drinkCoffee(coffee: Coffee) {
        NotificationCenter.default.post(
            name: RecipeViewModel.drinkConsumedNotification, 
            object: nil, 
            userInfo: ["coffeeType": coffee.type.rawValue]
        )
    }
    
    func shareRecipe() {
    }
} 
