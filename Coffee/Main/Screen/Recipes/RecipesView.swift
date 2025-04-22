import SwiftUI

// MARK: - Recipes View
struct RecipesView: View {
    var namespace: Namespace.ID
    @StateObject private var viewModel = RecipesViewModel()
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
                .padding(.top, 50)
                
                ScrollView(.vertical, showsIndicators: false) {
                    ZStack {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(borderColor, lineWidth: borderWidth)
                            .background(Color.clear)
                        
                        LazyVStack(spacing: 8) {
                            ForEach(viewModel.beverageList) { beverage in
                                if let coffee = beverage.coffee {
                                    CoffeeCategoryCell(
                                        title: beverage.title,
                                        subtitle: beverage.subtitle,
                                        image: coffee.type.image
                                    ) {
                                        print("Selected coffee: \(coffee.name)")
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
                    .padding(.horizontal, 16)
                    .padding(.bottom, 120)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                viewModel.loadData()
            }
            .onChange(of: showRecipeDetail) { newValue in
                print("showRecipeDetail changed to: \(newValue)")
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
struct RecipesViewPreview: View {
    @Namespace var namespace
    
    var body: some View {
        RecipesView(namespace: namespace)
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
    RecipesViewPreview()
} 
