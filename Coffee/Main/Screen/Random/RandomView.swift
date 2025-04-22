import SwiftUI

// MARK: - Random View
struct RandomView: View {
    var namespace: Namespace.ID
    @StateObject private var viewModel = RandomViewModel()
    @EnvironmentObject private var coordinator: MainCoordinator
    
    private let yellowStrokeColor = Color(red: 235/255, green: 192/255, blue: 117/255)
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Spacer()
                
                StrokedText(text: "You can get", size: 56, lineWidth: 15)
                
                Text("a recipe for a random coffee drink")
                    .customFont(.customRegular, size: 24)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                CustomButton(text: "RANDOMIZE", style: .red) {
                    viewModel.generateRandomCoffee()
                    viewModel.showResult = true
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .opacity(viewModel.showResult ? 0 : 1)
            .disabled(viewModel.showRecipe)
            
            if viewModel.showResult {
                GeometryReader { geometry in
                    VStack {
                        StrokedText(text: "Your drink is...", size: 44, lineWidth: 15)
                            .padding(.top, 50)
                        ZStack {
                            Rectangle()
                                .fill(Color(red: 245/255, green: 192/255, blue: 117/255))
                                .cornerRadius(40)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color(red: 255/255, green: 255/255, blue: 187/255), lineWidth: 2)
                                )
                                .frame(height: geometry.size.height * 0.2)
                                .padding(.horizontal, 20)
                                .offset(y: geometry.size.height * 0.23)
                            
                            Image("cup")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 1)
                                .offset(y: geometry.size.height * 0)
                            
                            Text(viewModel.selectedCoffeeType?.displayName ?? "Cappuccino")
                                .customFont(.customBold, size: 36)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .offset(y: geometry.size.height * 0.25)
                        }
                        .frame(height: geometry.size.height * 0.5)
                        
                        Spacer()
                        
                        CustomButton(text: "RECIPE", style: .red) {
                            viewModel.showRecipe = true
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                        
                    }
                }
                .opacity(viewModel.showRecipe ? 0 : 1)
                .disabled(viewModel.showRecipe)
            }
            
            if viewModel.showRecipe, let coffeeType = viewModel.selectedCoffeeType {
                let coffee = Coffee.personalizedRecipe(for: coffeeType)
                ZStack {
                    RecipeView(isPresented: $viewModel.showRecipe, coffee: coffee)
                }
            }
        }
        .onAppear {
            if !viewModel.showResult && !viewModel.showRecipe {
                viewModel.generateRandomCoffee()
            }
        }
    }
}

// MARK: - Preview
struct RandomViewPreview: View {
    @Namespace var namespace
    
    var body: some View {
        RandomView(namespace: namespace)
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
    RandomViewPreview()
} 
