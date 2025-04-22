import SwiftUI
import Combine

struct CoffeeItem: Identifiable, Codable, Equatable {
    let id = UUID()
    let name: String
    var isSelected: Bool = false
    
    static func == (lhs: CoffeeItem, rhs: CoffeeItem) -> Bool {
        return lhs.name == rhs.name && lhs.isSelected == rhs.isSelected
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, isSelected
    }
}

class CoffeeInventoryViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var title = "Coffee"
    @Published var coffeeItems: [CoffeeItem] = []
    
    // MARK: - Properties
    var onBackTapped: (() -> Void)?
    
    // MARK: - Initializer
    init() {
        loadData()
    }
    
    // MARK: - Methods
    func loadData() {
        coffeeItems = UserDefaultsManager.loadInventory().coffeeItems
    }
    
    func toggleSelection(for item: CoffeeItem) {
        if let index = coffeeItems.firstIndex(where: { $0.id == item.id }) {
            coffeeItems[index].isSelected.toggle()
            UserDefaultsManager.updateCoffeeItems(coffeeItems)
        }
    }
} 
