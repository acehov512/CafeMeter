import SwiftUI
import Combine

// MARK: - Recipes ViewModel
class RecipesViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var weekDay: String = ""
    @Published var currentDate: String = ""
    @Published var beverageList: [BeverageItem] = []
    
    // MARK: - Initializer
    init() {
        configureDateInfo()
        loadBeverageItems()
    }
    
    // MARK: - Methods
    private func configureDateInfo() {
        let today = Date()
        
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.dateFormat = "EEEE"
        weekdayFormatter.locale = Locale(identifier: "en_US")
        weekDay = weekdayFormatter.string(from: today)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        currentDate = dateFormatter.string(from: today)
    }
    
    private func loadBeverageItems() {
        beverageList = CoffeeType.allCases.map { type in
            let coffee = Coffee.personalizedRecipe(for: type)
            return BeverageItem(
                title: coffee.name,
                subtitle: "\(coffee.volume) ml",
                coffee: coffee
            )
        }
    }
    
    func loadData() {
        configureDateInfo()
        loadBeverageItems()
    }
    
    func getCoffeeRecipe(type: CoffeeType) -> Coffee {
        return Coffee.personalizedRecipe(for: type)
    }
}

// MARK: - Models
struct BeverageItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    var coffee: Coffee? = nil
} 
