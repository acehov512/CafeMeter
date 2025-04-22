import SwiftUI
import Combine

struct SyrupItem: Identifiable, Codable, Equatable {
    let id = UUID()
    let name: String
    var isSelected: Bool = false
    
    static func == (lhs: SyrupItem, rhs: SyrupItem) -> Bool {
        return lhs.name == rhs.name && lhs.isSelected == rhs.isSelected
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, isSelected
    }
}

class SyrupsInventoryViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var title = "Syrups"
    @Published var syrupItems: [SyrupItem] = []
    
    // MARK: - Properties
    var onBackTapped: (() -> Void)?
    
    // MARK: - Initializer
    init() {
        loadData()
    }
    
    // MARK: - Methods
    func loadData() {
        syrupItems = UserDefaultsManager.loadInventory().syrupItems
    }
    
    func toggleSelection(for item: SyrupItem) {
        if let index = syrupItems.firstIndex(where: { $0.id == item.id }) {
            syrupItems[index].isSelected.toggle()
            UserDefaultsManager.updateSyrupItems(syrupItems)
        }
    }
} 
