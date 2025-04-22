import Foundation

struct AllergenItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    var isSelected: Bool = false
}

// MARK: - Mock Data
extension AllergenItem {
    static let mockAllergens: [AllergenItem] = [
        AllergenItem(name: "Nuts"),
        AllergenItem(name: "Milk"),
        AllergenItem(name: "Soy"),
        AllergenItem(name: "Eggs"),
        AllergenItem(name: "Wheat"),
        AllergenItem(name: "Fish"),
        AllergenItem(name: "Shellfish"),
        AllergenItem(name: "Gluten")
    ]
} 