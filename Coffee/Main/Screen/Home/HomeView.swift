import SwiftUI

// MARK: - Home View
struct HomeView: View {
    var namespace: Namespace.ID
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject private var coordinator: MainCoordinator
    @State private var selectedCoffee: Coffee? = nil
    @State private var showRecipeDetail = false
    
    private let borderColor = Color(red: 245/255, green: 218/255, blue: 146/255)
    private let cornerRadius: CGFloat = 20
    private let borderWidth: CGFloat = 2
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text(viewModel.weekDay)
                        .customFont(.customBold, size: 44)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text(viewModel.currentDate)
                        .customFont(.customRegular, size: 24)
                        .foregroundColor(.white)
                        .padding(.trailing, 8)
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                
                Rectangle()
                    .fill(Color(red: 245/255, green: 218/255, blue: 146/255))
                    .frame(height: 100)
                    .cornerRadius(cornerRadius)
                    .overlay(
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("You've already had")
                                    .customFont(.customRegular, size: 24)
                                    .foregroundColor(Color(red: 152/255, green: 107/255, blue: 51/255)) // #986B33
                                
                                HStack {
                                    Text(viewModel.caffeineAmount)
                                        .customFont(.customBold, size: 40)
                                        .foregroundColor(viewModel.isCaffeineExceeded ? .red : Color(red: 102/255, green: 57/255, blue: 1/255))
                                    
                                    Text("caffeine")
                                        .customFont(.customBold, size: 20)
                                        .foregroundColor(viewModel.isCaffeineExceeded ? .red : Color(red: 102/255, green: 57/255, blue: 1/255))
                                }
                            }
                            .padding(.leading, 16)
                            
                            Spacer()
                            
                            ZStack {
                                Rectangle()
                                    .fill(Color(red: 152/255, green: 107/255, blue: 51/255))
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(10)
                                
                                Image("bean")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(Color(red: 245/255, green: 218/255, blue: 146/255))
                                    .frame(width: 60, height: 60)
                            }
                            .padding(.trailing, 12)
                        }
                    )
                    .padding(.horizontal, 16)
                
                Text("Latest drinks:")
                    .customFont(.customRegular, size: 24)
                    .foregroundColor(Color(red: 255/255, green: 241/255, blue: 203/255))
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                
                ScrollView(.vertical, showsIndicators: false) {
                    ZStack {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(borderColor, lineWidth: borderWidth)
                            .background(Color.clear)
                        
                        if viewModel.latestRecipes.isEmpty {
                            VStack {
                                Text("You haven't had any drinks yet")
                                    .customFont(.customRegular, size: 18)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                
                                Text("Try out some coffee recipes!")
                                    .customFont(.customRegular, size: 16)
                                    .foregroundColor(.white.opacity(0.7))
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                        } else {
                            LazyVStack(spacing: 8) {
                                ForEach(viewModel.latestRecipes) { beverage in
                                    if let coffee = beverage.coffee {
                                        CoffeeCategoryCell(
                                            title: beverage.title,
                                            subtitle: beverage.subtitle,
                                            image: coffee.type.image
                                        ) {
                                            print("Selected drink: \(beverage.title)")
                                            self.selectedCoffee = coffee
                                            withAnimation {
                                                self.showRecipeDetail = true
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(8)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 120)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                viewModel.loadUserData()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                viewModel.loadUserData()
            }
            .onChange(of: showRecipeDetail) { newValue in
                if !newValue {
                    selectedCoffee = nil
                }
            }
            .opacity(showRecipeDetail ? 0 : 1)
            .disabled(showRecipeDetail)
            
            if showRecipeDetail, let coffee = selectedCoffee {
                ZStack {
                    RecipeView(isPresented: $showRecipeDetail, coffee: coffee)
                }
                .onAppear {
                    print("RecipeView appeared for coffee: \(coffee.name)")
                }
            }
        }
    }
}

// MARK: - Preview
struct HomeViewPreview: View {
    @Namespace var namespace
    
    var body: some View {
        HomeView(namespace: namespace)
            .environmentObject(MainCoordinator())
            .background(
                Image("homeBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.customOrange)
            )
    }
}

#Preview {
    HomeViewPreview()
} 
