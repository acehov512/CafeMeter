import SwiftUI
import Combine

struct OptionalItem: Identifiable, Codable, Equatable {
    let id = UUID()
    let name: String
    var isSelected: Bool = false
    
    static func == (lhs: OptionalItem, rhs: OptionalItem) -> Bool {
        return lhs.name == rhs.name && lhs.isSelected == rhs.isSelected
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, isSelected
    }
}

class OptionalsInventoryViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var title = "Optionals"
    @Published var optionalItems: [OptionalItem] = []
    
    // MARK: - Properties
    var onBackTapped: (() -> Void)?
    
    // MARK: - Initializer
    init() {
        loadData()
    }
    
    // MARK: - Methods
    func loadData() {
        optionalItems = UserDefaultsManager.loadInventory().optionalItems
    }
    
    func toggleSelection(for item: OptionalItem) {
        if let index = optionalItems.firstIndex(where: { $0.id == item.id }) {
            optionalItems[index].isSelected.toggle()
            UserDefaultsManager.updateOptionalItems(optionalItems)
        }
    }
} 
