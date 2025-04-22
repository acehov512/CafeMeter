import SwiftUI
import Combine

// MARK: - Home ViewModel
class HomeViewModel: ObservableObject {
    @Published var title = "Main Screen"
    @Published var subtitle = "Welcome"
    @Published var weekDay = ""
    @Published var currentDate = ""
    @Published var caffeineAmount = "0 mg"
    @Published var latestRecipes: [BeverageItem] = []
    
    var isCaffeineExceeded: Bool {
        return todayCaffeineAmount > 400
    }
    
    private var cancellables = Set<AnyCancellable>()
    private var consumedCoffees: [Coffee] = []
    private var todayCaffeineAmount: Int = 0
    
    // MARK: - Constants
    private enum UserDefaultsKeys {
        static let consumedCoffeeTypes = "consumedCoffeeTypes"
        static let todayCaffeineAmount = "todayCaffeineAmount"
        static let lastSavedDate = "lastSavedDate"
    }
    
    init() {
        loadSavedData()
        configureDateInfo()
        loadLatestRecipes()
        setupNotificationObserver()
    }
    
    // MARK: - Public Methods
    func loadUserData() {
        configureDateInfo()
        loadLatestRecipes()
    }
    
    // MARK: - Private Methods
    private func configureDateInfo() {
        let today = Date()
        
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.dateFormat = "EEEE"
        weekdayFormatter.locale = Locale(identifier: "en_US")
        weekDay = weekdayFormatter.string(from: today)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        currentDate = dateFormatter.string(from: today)
        
        checkAndResetDailyValues(with: today)
    }
    
    private func checkAndResetDailyValues(with today: Date) {
        if let lastSavedDateString = UserDefaults.standard.string(forKey: UserDefaultsKeys.lastSavedDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            if let lastSavedDate = dateFormatter.date(from: lastSavedDateString) {
                let calendar = Calendar.current
                if !calendar.isDate(lastSavedDate, inSameDayAs: today) {
                    todayCaffeineAmount = 0
                    caffeineAmount = "0 mg"
                    saveDataToUserDefaults()
                }
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        UserDefaults.standard.set(dateFormatter.string(from: today), forKey: UserDefaultsKeys.lastSavedDate)
    }
    
    private func loadLatestRecipes() {
        if !consumedCoffees.isEmpty {
            latestRecipes = consumedCoffees.prefix(4).map { coffee in
                return BeverageItem(
                    title: coffee.name,
                    subtitle: "\(coffee.volume) ml",
                    coffee: coffee
                )
            }
        } else {
            latestRecipes = []
        }
    }
    
    private func setupNotificationObserver() {
        NotificationCenter.default.publisher(for: RecipeViewModel.drinkConsumedNotification)
            .sink { [weak self] notification in
                guard let self = self,
                      let userInfo = notification.userInfo,
                      let coffeeTypeRaw = userInfo["coffeeType"] as? String,
                      let coffeeType = CoffeeType(rawValue: coffeeTypeRaw) else { return }
                
                let coffee = Coffee.personalizedRecipe(for: coffeeType)
                self.addConsumedCoffee(coffee)
            }
            .store(in: &cancellables)
    }
    
    private func addConsumedCoffee(_ coffee: Coffee) {
        consumedCoffees.insert(coffee, at: 0)
        todayCaffeineAmount += coffee.caffeine
        caffeineAmount = "\(todayCaffeineAmount) mg"
        loadLatestRecipes()
        saveDataToUserDefaults()
    }
    
    private func loadSavedData() {
        todayCaffeineAmount = UserDefaults.standard.integer(forKey: UserDefaultsKeys.todayCaffeineAmount)
        caffeineAmount = "\(todayCaffeineAmount) mg"
        
        if let coffeeTypeStrings = UserDefaults.standard.array(forKey: UserDefaultsKeys.consumedCoffeeTypes) as? [String] {
            consumedCoffees = coffeeTypeStrings.compactMap { typeString in
                guard let type = CoffeeType(rawValue: typeString) else { return nil }
                return Coffee.personalizedRecipe(for: type)
            }
        }
    }
    
    private func saveDataToUserDefaults() {
        UserDefaults.standard.set(todayCaffeineAmount, forKey: UserDefaultsKeys.todayCaffeineAmount)
        let coffeeTypes = consumedCoffees.map { $0.type.rawValue }
        UserDefaults.standard.set(coffeeTypes, forKey: UserDefaultsKeys.consumedCoffeeTypes)
    }
} 
