import SwiftUI

class OnboardingViewModel: ObservableObject {
    enum QuestionType: Int, CaseIterable {
        case flavor = 0
        case frequency = 1
        case pureCoffee = 2
        case syrups = 3
        case allergies = 4
        case specificAllergies = 5
        
        var title: String {
            switch self {
            case .flavor:
                return "What flavor of coffee do you like?"
            case .frequency:
                return "How often do you drink coffee?"
            case .pureCoffee:
                return "Do you like to drink pure coffee?"
            case .syrups:
                return "Do you like to add syrups to your coffee?"
            case .allergies:
                return "Are you allergic to any foods?"
            case .specificAllergies:
                return "What specific foods are you allergic to?"
            }
        }
        
        var options: [String] {
            switch self {
            case .flavor:
                return ["Sour", "Bitter", "Tart", "Fruity"]
            case .frequency:
                return ["Less than 1 a week", "1 a week", "2 - 3 times a week", "1 a day", "More than 1 a day"]
            case .pureCoffee, .syrups, .allergies:
                return ["Yes", "No"]
            case .specificAllergies:
                return []
            }
        }
    }
    
    @Published var currentQuestionIndex = 0
    @Published var selectedOptions: [Int: Int] = [:]
    @Published var allergens: [AllergenItem] = AllergenItem.mockAllergens
    @Published var showAllergens = false
    
    var navigateToNextScreen: (() -> Void)?
    
    var currentQuestion: QuestionType {
        return QuestionType(rawValue: currentQuestionIndex) ?? .flavor
    }
    
    var canGoBack: Bool {
        return currentQuestionIndex > 0
    }
    
    var canGoForward: Bool {
        if currentQuestion == .specificAllergies {
            if let selectedAllergies = selectedOptions[QuestionType.allergies.rawValue], 
               selectedAllergies == 0 {
                return allergens.contains(where: { $0.isSelected })
            } else {
                return true 
            }
        } else {
            return selectedOptions[currentQuestionIndex] != nil
        }
    }
    
    var isLastQuestion: Bool {
        return currentQuestionIndex == QuestionType.allCases.count - 1
    }
    
    func nextQuestion() {
        if currentQuestionIndex < QuestionType.allCases.count - 1 {
            if currentQuestion == .allergies, 
               let selectedAllergies = selectedOptions[QuestionType.allergies.rawValue], 
               selectedAllergies == 1 {
                if currentQuestionIndex == QuestionType.allCases.count - 2 {
                    finishOnboarding()
                } else {
                    currentQuestionIndex = QuestionType.allCases.count - 1
                }
                return
            }
            
            currentQuestionIndex += 1
            
            if currentQuestion == .specificAllergies {
                showAllergens = true
            } else {
                showAllergens = false
            }
        } else {
            finishOnboarding()
        }
    }
    
    func previousQuestion() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
            showAllergens = false
        }
    }
    
    func selectOption(at index: Int) {
        selectedOptions[currentQuestionIndex] = index
    }
    
    func toggleAllergen(at index: Int) {
        allergens[index].isSelected.toggle()
    }
    
    func finishOnboarding() {
        print("Onboarding completed with answers: \(selectedOptions)")
        print("Selected allergens: \(allergens.filter { $0.isSelected }.map { $0.name })")
        
        savePreferencesToUserDefaults()
        
        DispatchQueue.main.async {
            self.navigateToNextScreen?()
        }
    }
    
    private func savePreferencesToUserDefaults() {
        let selectedAllergens = allergens.filter { $0.isSelected }.map { $0.name }
        
        if let flavorIndex = selectedOptions[QuestionType.flavor.rawValue] {
            UserDefaults.standard.setValue(QuestionType.flavor.options[flavorIndex], forKey: "userCoffeeFlavor")
        }
        
        if let frequencyIndex = selectedOptions[QuestionType.frequency.rawValue] {
            UserDefaults.standard.setValue(QuestionType.frequency.options[frequencyIndex], forKey: "userCoffeeFrequency")
        }
        
        if let pureCoffeeIndex = selectedOptions[QuestionType.pureCoffee.rawValue] {
            let likesPureCoffee = pureCoffeeIndex == 0
            UserDefaults.standard.setValue(likesPureCoffee, forKey: "userLikesPureCoffee")
        }
        
        if let syrupsIndex = selectedOptions[QuestionType.syrups.rawValue] {
            let likesSyrups = syrupsIndex == 0
            UserDefaults.standard.setValue(likesSyrups, forKey: "userLikesSyrups")
        }
        
        if let allergiesIndex = selectedOptions[QuestionType.allergies.rawValue] {
            let hasAllergies = allergiesIndex == 0
            UserDefaults.standard.setValue(hasAllergies, forKey: "userHasAllergies")
        }
        
        UserDefaults.standard.setValue(selectedAllergens, forKey: "userAllergens")
        
        UserDefaults.standard.synchronize()
    }
} 
