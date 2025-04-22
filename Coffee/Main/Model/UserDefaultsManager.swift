import Foundation

// MARK: - Storage Manager
final class UserDefaultsManager {
    private enum Keys {
        static let inventoryItems = "inventoryItems"
    }
    
    static func saveInventory(_ inventory: InventoryItems) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(inventory)
            UserDefaults.standard.set(data, forKey: Keys.inventoryItems)
        } catch {
            assertionFailure("Inventory encoding error: \(error.localizedDescription)")
        }
    }
    
    static func loadInventory() -> InventoryItems {
        guard let data = UserDefaults.standard.data(forKey: Keys.inventoryItems) else {
            return InventoryItems.defaultItems
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(InventoryItems.self, from: data)
        } catch {
            assertionFailure("Inventory decoding error: \(error.localizedDescription)")
            return InventoryItems.defaultItems
        }
    }
    
    static func updateCoffeeItems(_ items: [CoffeeItem]) {
        var inventory = loadInventory()
        inventory.coffeeItems = items
        saveInventory(inventory)
    }
    
    static func updateDrinkItems(_ items: [DrinkItem]) {
        var inventory = loadInventory()
        inventory.drinkItems = items
        saveInventory(inventory)
    }
    
    static func updateSyrupItems(_ items: [SyrupItem]) {
        var inventory = loadInventory()
        inventory.syrupItems = items
        saveInventory(inventory)
    }
    
    static func updateOptionalItems(_ items: [OptionalItem]) {
        var inventory = loadInventory()
        inventory.optionalItems = items
        saveInventory(inventory)
    }
}