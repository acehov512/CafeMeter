import SwiftUI
import Combine

class InventoryViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var title = "Inventory"
    @Published var inventoryItems: InventoryItems?
    
    // MARK: - Initializer
    init() {
        loadData()
    }
    
    // MARK: - Methods
    func loadData() {
        inventoryItems = UserDefaultsManager.loadInventory()
    }
} 
