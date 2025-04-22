import SwiftUI

// MARK: - Types
enum CoffeeType: String, CaseIterable, Identifiable {
    case espresso = "espresso"
    case americano = "americano"
    case cappuccino = "cappuccino"
    case latte = "latte"
    case flatWhite = "flatWhite"
    case mocha = "mocha"
    case macchiato = "macchiato"
    case ristretto = "ristretto"
    case doppio = "doppio"
    case matcha = "matcha"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .espresso: return "Espresso"
        case .americano: return "Americano"
        case .cappuccino: return "Cappuccino"
        case .latte: return "Latte"
        case .flatWhite: return "Flat White"
        case .mocha: return "Mocha"
        case .macchiato: return "Macchiato"
        case .ristretto: return "Ristretto"
        case .doppio: return "Doppio"
        case .matcha: return "Matcha"
        }
    }
    
    var image: Image {
        return Image(self.rawValue)
    }
    
    func debugImagePath() -> String {
        return self.rawValue
    }
}

// MARK: - Models
struct RecipeStep {
    let order: Int
    let description: String
}

struct Ingredient: Identifiable {
    let id = UUID()
    let name: String
    let amount: String
    var isRequired: Bool
    var isAvailable: Bool = false
    
    enum Category {
        case coffee
        case drink
        case optional
        case syrup
    }
    
    let category: Category
}

struct Coffee: Identifiable {
    let id = UUID()
    let type: CoffeeType
    let volume: Int
    let caffeine: Int
    let ingredients: [Ingredient]
    let preparationSteps: [RecipeStep]
    let description: String
    
    var name: String { type.displayName }
    var image: Image { type.image }
    
    var isAvailable: Bool {
        let requiredIngredients = ingredients.filter { $0.isRequired }
        return requiredIngredients.allSatisfy { $0.isAvailable }
    }
    
    var missingIngredients: [Ingredient] {
        ingredients.filter { $0.isRequired && !$0.isAvailable }
    }
    
    var availableOptionalIngredients: [Ingredient] {
        ingredients.filter { !$0.isRequired && $0.isAvailable }
    }
    
    func customized(with inventoryItems: InventoryItems) -> Coffee {
        var updatedIngredients = self.ingredients
        
        for (index, ingredient) in updatedIngredients.enumerated() {
            switch ingredient.category {
            case .coffee:
                if let coffeeItem = inventoryItems.coffeeItems.first(where: { $0.name == ingredient.name }) {
                    updatedIngredients[index].isAvailable = coffeeItem.isSelected
                }
            case .drink:
                if let drinkItem = inventoryItems.drinkItems.first(where: { $0.name == ingredient.name }) {
                    updatedIngredients[index].isAvailable = drinkItem.isSelected
                }
            case .optional:
                if let optionalItem = inventoryItems.optionalItems.first(where: { $0.name == ingredient.name }) {
                    updatedIngredients[index].isAvailable = optionalItem.isSelected
                }
            case .syrup:
                if let syrupItem = inventoryItems.syrupItems.first(where: { $0.name == ingredient.name }) {
                    updatedIngredients[index].isAvailable = syrupItem.isSelected
                }
            }
        }
        
        return Coffee(
            type: self.type,
            volume: self.volume,
            caffeine: self.caffeine,
            ingredients: updatedIngredients,
            preparationSteps: self.preparationSteps,
            description: self.description
        )
    }
    
    static func customizedByInventory(coffeeType: CoffeeType) -> Coffee {
        let personalizedCoffee = personalizedRecipe(for: coffeeType)
        let inventoryItems = UserDefaultsManager.loadInventory()
        return personalizedCoffee.customized(with: inventoryItems)
    }
    
    static func create(type: CoffeeType) -> Coffee {
        switch type {
        case .espresso:
            return Coffee(
                type: .espresso,
                volume: 30,
                caffeine: 63,
                ingredients: [
                    Ingredient(name: "Arabica", amount: "7g", isRequired: true, category: .coffee),
                    Ingredient(name: "Water", amount: "30ml", isRequired: true, category: .optional),
                    Ingredient(name: "Cane sugar", amount: "To taste", isRequired: false, category: .optional)
                ],
                preparationSteps: [
                    RecipeStep(order: 1, description: "Grind Arabica coffee beans to a fine consistency"),
                    RecipeStep(order: 2, description: "Tamp the coffee grounds evenly in the portafilter"),
                    RecipeStep(order: 3, description: "Extract 30ml of espresso in approximately 25-30 seconds"),
                    RecipeStep(order: 4, description: "If desired, add cane sugar to taste")
                ],
                description: "A concentrated coffee served in a small, strong shot. The foundation of many coffee drinks with a rich crema on top."
            )
        case .americano:
            return Coffee(
                type: .americano,
                volume: 150,
                caffeine: 63,
                ingredients: [
                    Ingredient(name: "Arabica", amount: "7g", isRequired: true, category: .coffee),
                    Ingredient(name: "Water", amount: "120ml", isRequired: true, category: .optional),
                    Ingredient(name: "Cane sugar", amount: "To taste", isRequired: false, category: .optional),
                    Ingredient(name: "Cream", amount: "To taste", isRequired: false, category: .optional)
                ],
                preparationSteps: [
                    RecipeStep(order: 1, description: "Prepare a shot of espresso using Arabica coffee"),
                    RecipeStep(order: 2, description: "Heat 120ml of water to approximately 85°C"),
                    RecipeStep(order: 3, description: "Pour the hot water into a cup"),
                    RecipeStep(order: 4, description: "Add the espresso to the hot water"),
                    RecipeStep(order: 5, description: "Add optional cane sugar or cream if desired")
                ],
                description: "An espresso diluted with hot water, making it similar in strength to regular drip coffee but with a different flavor profile."
            )
        case .cappuccino:
            return Coffee(
                type: .cappuccino,
                volume: 150,
                caffeine: 63,
                ingredients: [
                    Ingredient(name: "Arabica", amount: "7g", isRequired: true, category: .coffee),
                    Ingredient(name: "Milk", amount: "60ml", isRequired: true, category: .optional),
                    Ingredient(name: "Lactose-free milk", amount: "60ml", isRequired: false, category: .optional),
                    Ingredient(name: "Cinnamon", amount: "A sprinkle", isRequired: false, category: .optional),
                    Ingredient(name: "Chocolate", amount: "A drizzle", isRequired: false, category: .syrup),
                    Ingredient(name: "Caramel", amount: "A drizzle", isRequired: false, category: .syrup)
                ],
                preparationSteps: [
                    RecipeStep(order: 1, description: "Prepare a shot of espresso using Arabica coffee"),
                    RecipeStep(order: 2, description: "Steam and froth milk to create microfoam"),
                    RecipeStep(order: 3, description: "Pour the steamed milk over the espresso"),
                    RecipeStep(order: 4, description: "Top with a generous layer of milk foam"),
                    RecipeStep(order: 5, description: "Optional: Sprinkle with cinnamon or drizzle with chocolate or caramel syrup")
                ],
                description: "A classic Italian coffee with equal parts espresso, steamed milk, and milk foam, creating a perfect balance of flavors."
            )
        case .latte:
            return Coffee(
                type: .latte,
                volume: 240,
                caffeine: 63,
                ingredients: [
                    Ingredient(name: "Arabica", amount: "7g", isRequired: true, category: .coffee),
                    Ingredient(name: "Milk", amount: "180ml", isRequired: true, category: .optional),
                    Ingredient(name: "Lactose-free milk", amount: "180ml", isRequired: false, category: .optional),
                    Ingredient(name: "Caramel", amount: "15ml", isRequired: false, category: .syrup),
                    Ingredient(name: "Chocolate", amount: "15ml", isRequired: false, category: .syrup),
                    Ingredient(name: "Hazelnut", amount: "15ml", isRequired: false, category: .syrup),
                    Ingredient(name: "Cinnamon", amount: "A sprinkle", isRequired: false, category: .optional)
                ],
                preparationSteps: [
                    RecipeStep(order: 1, description: "Prepare a shot of espresso using Arabica coffee"),
                    RecipeStep(order: 2, description: "Steam milk until smooth and velvety"),
                    RecipeStep(order: 3, description: "Pour the steamed milk over the espresso, holding back the foam"),
                    RecipeStep(order: 4, description: "Add a thin layer of milk foam on top"),
                    RecipeStep(order: 5, description: "Optional: Add flavoring syrup or sprinkle with cinnamon")
                ],
                description: "A creamy coffee drink with espresso and steamed milk, topped with a small layer of milk foam. Can be customized with various flavored syrups."
            )
        case .flatWhite:
            return Coffee(
                type: .flatWhite,
                volume: 160,
                caffeine: 130,
                ingredients: [
                    Ingredient(name: "Arabica", amount: "14g", isRequired: true, category: .coffee),
                    Ingredient(name: "Milk", amount: "100ml", isRequired: true, category: .optional),
                    Ingredient(name: "Lactose-free milk", amount: "100ml", isRequired: false, category: .optional)
                ],
                preparationSteps: [
                    RecipeStep(order: 1, description: "Prepare a double shot of espresso using Arabica coffee"),
                    RecipeStep(order: 2, description: "Steam milk to create microfoam with a silky texture"),
                    RecipeStep(order: 3, description: "Pour the steamed milk over the espresso with minimal foam"),
                    RecipeStep(order: 4, description: "The result should have a velvety texture with a higher coffee-to-milk ratio than a latte")
                ],
                description: "An Australian/New Zealand coffee drink similar to a latte but with less milk and a higher coffee-to-milk ratio. Served with a thin layer of microfoam."
            )
        case .mocha:
            return Coffee(
                type: .mocha,
                volume: 280,
                caffeine: 63,
                ingredients: [
                    Ingredient(name: "Arabica", amount: "7g", isRequired: true, category: .coffee),
                    Ingredient(name: "Milk", amount: "180ml", isRequired: true, category: .optional),
                    Ingredient(name: "Lactose-free milk", amount: "180ml", isRequired: false, category: .optional),
                    Ingredient(name: "Chocolate", amount: "30ml", isRequired: true, category: .syrup),
                    Ingredient(name: "Cream", amount: "A dollop", isRequired: false, category: .optional),
                    Ingredient(name: "Chocolate chips", amount: "A sprinkle", isRequired: false, category: .optional),
                    Ingredient(name: "Caramel", amount: "A drizzle", isRequired: false, category: .syrup)
                ],
                preparationSteps: [
                    RecipeStep(order: 1, description: "Prepare a shot of espresso using Arabica coffee"),
                    RecipeStep(order: 2, description: "Mix chocolate syrup with the hot espresso"),
                    RecipeStep(order: 3, description: "Steam milk until smooth and velvety"),
                    RecipeStep(order: 4, description: "Pour the steamed milk over the chocolate-espresso mixture"),
                    RecipeStep(order: 5, description: "Optional: Top with cream, chocolate chips, or a caramel drizzle")
                ],
                description: "A delicious combination of espresso, steamed milk, and chocolate, sometimes topped with whipped cream and additional chocolate for a dessert-like coffee experience."
            )
        case .macchiato:
            return Coffee(
                type: .macchiato,
                volume: 40,
                caffeine: 63,
                ingredients: [
                    Ingredient(name: "Arabica", amount: "7g", isRequired: true, category: .coffee),
                    Ingredient(name: "Milk", amount: "10ml", isRequired: true, category: .optional),
                    Ingredient(name: "Caramel", amount: "5ml", isRequired: false, category: .syrup)
                ],
                preparationSteps: [
                    RecipeStep(order: 1, description: "Prepare a shot of espresso using Arabica coffee"),
                    RecipeStep(order: 2, description: "Steam a small amount of milk to create microfoam"),
                    RecipeStep(order: 3, description: "Spoon a dollop of milk foam on top of the espresso"),
                    RecipeStep(order: 4, description: "Optional: Add a small amount of caramel syrup")
                ],
                description: "An espresso 'stained' or 'marked' with a small amount of milk foam, resulting in a stronger coffee flavor with just a hint of milk."
            )
        case .ristretto:
            return Coffee(
                type: .ristretto,
                volume: 20,
                caffeine: 60,
                ingredients: [
                    Ingredient(name: "Arabica", amount: "7g", isRequired: true, category: .coffee),
                    Ingredient(name: "Water", amount: "20ml", isRequired: true, category: .optional),
                    Ingredient(name: "Cane sugar", amount: "To taste", isRequired: false, category: .optional)
                ],
                preparationSteps: [
                    RecipeStep(order: 1, description: "Grind Arabica coffee beans to a fine consistency"),
                    RecipeStep(order: 2, description: "Tamp the coffee grounds evenly in the portafilter"),
                    RecipeStep(order: 3, description: "Extract only 20ml of espresso in approximately 15-20 seconds"),
                    RecipeStep(order: 4, description: "Optional: Add cane sugar to taste")
                ],
                description: "A 'restricted' shot of espresso using the same amount of coffee but less water, resulting in a more concentrated, rich flavor profile."
            )
        case .doppio:
            return Coffee(
                type: .doppio,
                volume: 60,
                caffeine: 126,
                ingredients: [
                    Ingredient(name: "Arabica", amount: "14g", isRequired: true, category: .coffee),
                    Ingredient(name: "Water", amount: "60ml", isRequired: true, category: .optional),
                    Ingredient(name: "Cane sugar", amount: "To taste", isRequired: false, category: .optional)
                ],
                preparationSteps: [
                    RecipeStep(order: 1, description: "Grind Arabica coffee beans to a fine consistency"),
                    RecipeStep(order: 2, description: "Use a double portafilter basket with 14g of ground coffee"),
                    RecipeStep(order: 3, description: "Tamp the coffee grounds evenly"),
                    RecipeStep(order: 4, description: "Extract 60ml of espresso in approximately 25-30 seconds"),
                    RecipeStep(order: 5, description: "Optional: Add cane sugar to taste")
                ],
                description: "A double shot of espresso, twice the amount of a single shot, providing a stronger coffee experience with more caffeine."
            )
        case .matcha:
            return Coffee(
                type: .matcha,
                volume: 240,
                caffeine: 70,
                ingredients: [
                    Ingredient(name: "Matcha", amount: "2g", isRequired: true, category: .drink),
                    Ingredient(name: "Water", amount: "60ml", isRequired: true, category: .optional),
                    Ingredient(name: "Milk", amount: "180ml", isRequired: true, category: .optional),
                    Ingredient(name: "Lactose-free milk", amount: "180ml", isRequired: false, category: .optional),
                    Ingredient(name: "Cane sugar", amount: "To taste", isRequired: false, category: .optional),
                    Ingredient(name: "Vanilla", amount: "A few drops", isRequired: false, category: .optional)
                ],
                preparationSteps: [
                    RecipeStep(order: 1, description: "Heat water to 80°C, not boiling"),
                    RecipeStep(order: 2, description: "Add matcha powder to a cup or bowl"),
                    RecipeStep(order: 3, description: "Pour the hot water over the matcha and whisk until smooth"),
                    RecipeStep(order: 4, description: "Steam milk until smooth and velvety"),
                    RecipeStep(order: 5, description: "Pour the steamed milk over the matcha mixture"),
                    RecipeStep(order: 6, description: "Optional: Add cane sugar or a few drops of vanilla if desired")
                ],
                description: "A Japanese green tea latte made with finely ground matcha powder, hot water, and steamed milk, offering a unique earthy flavor with caffeine."
            )
        }
    }
}

// MARK: - Inventory
struct InventoryItems: Codable {
    var coffeeItems: [CoffeeItem]
    var drinkItems: [DrinkItem]
    var optionalItems: [OptionalItem]
    var syrupItems: [SyrupItem]
    
    static var defaultItems: InventoryItems {
        return InventoryItems(
            coffeeItems: [
                CoffeeItem(name: "Arabica", isSelected: true),
                CoffeeItem(name: "Robusta", isSelected: false),
                CoffeeItem(name: "Colombia", isSelected: false),
                CoffeeItem(name: "Dicofinate", isSelected: false)
            ],
            drinkItems: [
                DrinkItem(name: "Cocoa", isSelected: true),
                DrinkItem(name: "Hot chocolate", isSelected: false),
                DrinkItem(name: "Matcha", isSelected: false)
            ],
            optionalItems: [
                OptionalItem(name: "Milk", isSelected: true),
                OptionalItem(name: "Lactose-free milk", isSelected: false),
                OptionalItem(name: "Cinnamon", isSelected: false),
                OptionalItem(name: "Cane sugar", isSelected: false),
                OptionalItem(name: "Cream", isSelected: false),
                OptionalItem(name: "Chocolate chips", isSelected: false)
            ],
            syrupItems: [
                SyrupItem(name: "Caramel", isSelected: true),
                SyrupItem(name: "Chocolate", isSelected: false),
                SyrupItem(name: "Cherry", isSelected: false),
                SyrupItem(name: "Hazelnut", isSelected: false)
            ]
        )
    }
}

// MARK: - Personalization
extension Coffee {
    static func personalizedRecipe(for coffeeType: CoffeeType) -> Coffee {
        let standardRecipe = Coffee.create(type: coffeeType)
        
        let likesPureCoffee = UserDefaults.standard.bool(forKey: "userLikesPureCoffee")
        let likesSyrups = UserDefaults.standard.bool(forKey: "userLikesSyrups")
        let hasAllergies = UserDefaults.standard.bool(forKey: "userHasAllergies")
        let userAllergens = UserDefaults.standard.stringArray(forKey: "userAllergens") ?? []
        let coffeeFlavor = UserDefaults.standard.string(forKey: "userCoffeeFlavor")
        
        let inventoryItems = UserDefaultsManager.loadInventory()
        var updatedIngredients = standardRecipe.ingredients
        
        for (index, ingredient) in updatedIngredients.enumerated() {
            switch ingredient.category {
            case .coffee:
                let isAvailable = inventoryItems.coffeeItems.contains { coffeeItem in
                    coffeeItem.name.lowercased() == ingredient.name.lowercased() && coffeeItem.isSelected
                }
                updatedIngredients[index].isAvailable = isAvailable
                
                if ingredient.isRequired && !isAvailable {
                    if let availableCoffee = inventoryItems.coffeeItems.first(where: { $0.isSelected }) {
                        updatedIngredients[index] = Ingredient(
                            name: availableCoffee.name,
                            amount: ingredient.amount,
                            isRequired: ingredient.isRequired,
                            isAvailable: true,
                            category: ingredient.category
                        )
                    }
                }
                
            case .drink:
                let isAvailable = inventoryItems.drinkItems.contains { drinkItem in
                    drinkItem.name.lowercased() == ingredient.name.lowercased() && drinkItem.isSelected
                }
                updatedIngredients[index].isAvailable = isAvailable
                
            case .syrup:
                let isAvailable = inventoryItems.syrupItems.contains { syrupItem in
                    syrupItem.name.lowercased() == ingredient.name.lowercased() && syrupItem.isSelected
                }
                updatedIngredients[index].isAvailable = isAvailable && likesSyrups
                
            case .optional:
                let isAvailable = inventoryItems.optionalItems.contains { optionalItem in
                    optionalItem.name.lowercased() == ingredient.name.lowercased() && optionalItem.isSelected
                }
                updatedIngredients[index].isAvailable = isAvailable
            }
        }
        
        if hasAllergies {
            for (index, ingredient) in updatedIngredients.enumerated() {
                if userAllergens.contains(where: { allergen in 
                    ingredient.name.lowercased().contains(allergen.lowercased())
                }) {
                    updatedIngredients[index].isAvailable = false
                    
                    if ingredient.isRequired {
                        if ingredient.name.lowercased() == "milk" && updatedIngredients.contains(where: { $0.name == "Lactose-free milk" }) {
                            if let lactoseFreeIndex = updatedIngredients.firstIndex(where: { $0.name == "Lactose-free milk" }) {
                                let lactoseFreeAvailable = inventoryItems.optionalItems.contains { $0.name == "Lactose-free milk" && $0.isSelected }
                                updatedIngredients[lactoseFreeIndex].isAvailable = lactoseFreeAvailable
                                updatedIngredients[lactoseFreeIndex].isRequired = true
                            }
                        }
                    }
                }
            }
        }
        
        if !likesSyrups {
            for (index, ingredient) in updatedIngredients.enumerated() {
                if ingredient.category == .syrup {
                    updatedIngredients[index].isRequired = false
                    updatedIngredients[index].isAvailable = false
                }
            }
        }
        
        if likesPureCoffee {
            for (index, ingredient) in updatedIngredients.enumerated() {
                if ingredient.category == .optional || ingredient.category == .syrup {
                    updatedIngredients[index].isRequired = false
                }
            }
        }
        
        if let flavor = coffeeFlavor {
            var description = standardRecipe.description
            
            switch flavor {
            case "Sour":
                if !description.contains("with a sour finish") {
                    description += " Prepared with a special technique to enhance the natural acidity for a sour finish."
                }
            case "Bitter":
                if !description.contains("with a strong, bitter finish") {
                    description += " Brewed to enhance the robust, bitter notes that true coffee enthusiasts appreciate."
                }
            case "Tart":
                if !description.contains("with a tart profile") {
                    description += " Enhanced with a brewing technique that brings out the tart, wine-like profile."
                }
            case "Fruity":
                if !description.contains("fruity notes") {
                    description += " Carefully prepared to highlight the natural fruity notes of the coffee beans."
                }
            default:
                break
            }
            
            let canBePrepared = updatedIngredients.filter { $0.isRequired }.allSatisfy { $0.isAvailable }
            
            if !canBePrepared {
                let missingIngredients = updatedIngredients
                    .filter { $0.isRequired && !$0.isAvailable }
                    .map { $0.name }
                    .joined(separator: ", ")
                
                description += "\n\nUnavailable: This recipe requires ingredients that are not in your inventory: \(missingIngredients)."
            } else {
                description += "\n\nReady to prepare: You have all the necessary ingredients!"
            }
            
            return Coffee(
                type: standardRecipe.type,
                volume: standardRecipe.volume,
                caffeine: standardRecipe.caffeine,
                ingredients: updatedIngredients,
                preparationSteps: standardRecipe.preparationSteps,
                description: description
            )
        }
        
        let canBePrepared = updatedIngredients.filter { $0.isRequired }.allSatisfy { $0.isAvailable }
        var description = standardRecipe.description
        
        if !canBePrepared {
            let missingIngredients = updatedIngredients
                .filter { $0.isRequired && !$0.isAvailable }
                .map { $0.name }
                .joined(separator: ", ")
            
            description += "\n\nUnavailable: This recipe requires ingredients that are not in your inventory: \(missingIngredients)."
        } else {
            description += "\n\nReady to prepare: You have all the necessary ingredients!"
        }
        
        return Coffee(
            type: standardRecipe.type,
            volume: standardRecipe.volume,
            caffeine: standardRecipe.caffeine,
            ingredients: updatedIngredients,
            preparationSteps: standardRecipe.preparationSteps,
            description: description
        )
    }
} 
