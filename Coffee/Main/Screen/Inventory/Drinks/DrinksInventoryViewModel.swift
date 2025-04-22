import SwiftUI
import Combine

struct DrinkItem: Identifiable, Codable, Equatable {
    let id = UUID()
    let name: String
    var isSelected: Bool = false
    
    static func == (lhs: DrinkItem, rhs: DrinkItem) -> Bool {
        return lhs.name == rhs.name && lhs.isSelected == rhs.isSelected
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, isSelected
    }
}

class DrinksInventoryViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var title = "Drinks"
    @Published var drinkItems: [DrinkItem] = []
    
    // MARK: - Properties
    var onBackTapped: (() -> Void)?
    
    // MARK: - Initializer
    init() {
        loadData()
    }
    
    // MARK: - Methods
    func loadData() {
        drinkItems = UserDefaultsManager.loadInventory().drinkItems
    }
    
    func toggleSelection(for item: DrinkItem) {
        if let index = drinkItems.firstIndex(where: { $0.id == item.id }) {
            drinkItems[index].isSelected.toggle()
            UserDefaultsManager.updateDrinkItems(drinkItems)
        }
    }
} 
