import SwiftUI

// MARK: - Recipe View
struct RecipeView: View {
    @Binding var isPresented: Bool
    let coffee: Coffee
    @StateObject private var viewModel = RecipeViewModel()
    
    private let yellowStrokeColor = Color(red: 235/255, green: 192/255, blue: 117/255)
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ZStack {
                        Rectangle()
                            .fill(Color(red: 255/255, green: 212/255, blue: 137/255))
                            .frame(height: 60)
                        
                        StrokedText(text: coffee.name, size: 24, lineWidth: 15, strokeColor: yellowStrokeColor)
                    }
                    
                    ZStack(alignment: .topLeading) {
                        VStack(spacing: 30) {
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(spacing: 0) {
                                    Rectangle()
                                        .fill(Color.clear)
                                        .frame(width: 100)
                                    
                                    ZStack {
                                        Rectangle()
                                            .fill(Color(red: 255/255, green: 212/255, blue: 137/255))
                                            .frame(height: 44)
                                        
                                        StrokedText(text: "Amount of caffeine", size: 16, lineWidth: 10, strokeColor: yellowStrokeColor)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.leading, geometry.size.width / 2 + 10 - 100)
                                    }
                                }
                                .padding(.leading, 20)
                                
                                Text("\(coffee.caffeine) mg")
                                    .customFont(.customBold, size: 32)
                                    .foregroundColor(.white)
                                    .padding(.leading, geometry.size.width / 2 + 30)
                                    .padding(.top, 10)
                            }
                            
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(spacing: 0) {
                                    Rectangle()
                                        .fill(Color.clear)
                                        .frame(width: 100)
                                    
                                    ZStack {
                                        Rectangle()
                                            .fill(Color(red: 255/255, green: 212/255, blue: 137/255))
                                            .frame(height: 44)
                                        
                                        StrokedText(text: "Drink volume", size: 16, lineWidth: 10, strokeColor: yellowStrokeColor)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.leading, geometry.size.width / 2 + 10 - 100)
                                    }
                                }
                                .padding(.leading, 20)
                                
                                Text("\(coffee.volume) ml")
                                    .customFont(.customBold, size: 32)
                                    .foregroundColor(.white)
                                    .padding(.leading, geometry.size.width / 2 + 30)
                                    .padding(.top, 10)
                            }
                        }
                        
                        coffee.image
                            .resizable()
                            .scaledToFill()
                            .cornerRadius(20)
                            .frame(width: 200, height: 200)
                            .zIndex(1)
                            .padding(.leading, 20)
                    }
                    
                    StrokedText(text: "Cooking recipe", size: 32, lineWidth: 10)
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text(coffee.description)
                        .customFont(.customRegular, size: 16)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        StrokedText(text: "Ingredients", size: 24, lineWidth: 8)
                            .padding(.horizontal, 20)
                        
                        ForEach(coffee.ingredients.filter { $0.isRequired && $0.isAvailable }) { ingredient in
                            HStack {
                                Text("• \(ingredient.name)")
                                    .customFont(.customRegular, size: 16)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Text(ingredient.amount)
                                    .customFont(.customRegular, size: 16)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .padding(.horizontal, 30)
                        }
                        
                        if !coffee.ingredients.filter({ $0.isRequired && !$0.isAvailable }).isEmpty {
                            StrokedText(text: "Missing ingredients", size: 20, lineWidth: 6)
                                .padding(.top, 10)
                                .padding(.horizontal, 20)
                                .foregroundColor(Color.red.opacity(0.8))
                            
                            ForEach(coffee.ingredients.filter { $0.isRequired && !$0.isAvailable }) { ingredient in
                                HStack {
                                    Text("• \(ingredient.name)")
                                        .customFont(.customRegular, size: 16)
                                        .foregroundColor(.red.opacity(0.8))
                                    
                                    Spacer()
                                    
                                    Text(ingredient.amount)
                                        .customFont(.customRegular, size: 16)
                                        .foregroundColor(.red.opacity(0.7))
                                }
                                .padding(.horizontal, 30)
                            }
                        }
                        
                        if !coffee.ingredients.filter({ !$0.isRequired && $0.isAvailable }).isEmpty {
                            StrokedText(text: "Optional", size: 20, lineWidth: 6)
                                .padding(.top, 10)
                                .padding(.horizontal, 20)
                            
                            ForEach(coffee.ingredients.filter { !$0.isRequired && $0.isAvailable }) { ingredient in
                                HStack {
                                    Text("• \(ingredient.name)")
                                        .customFont(.customRegular, size: 16)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Text(ingredient.amount)
                                        .customFont(.customRegular, size: 16)
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                .padding(.horizontal, 30)
                            }
                        }
                        
                        if !coffee.ingredients.filter({ !$0.isRequired && !$0.isAvailable }).isEmpty {
                            StrokedText(text: "Unavailable optional", size: 20, lineWidth: 6)
                                .padding(.top, 10)
                                .padding(.horizontal, 20)
                            
                            ForEach(coffee.ingredients.filter { !$0.isRequired && !$0.isAvailable }) { ingredient in
                                HStack {
                                    Text("• \(ingredient.name)")
                                        .customFont(.customRegular, size: 16)
                                        .foregroundColor(.white.opacity(0.5))
                                        .strikethrough()
                                    
                                    Spacer()
                                    
                                    Text(ingredient.amount)
                                        .customFont(.customRegular, size: 16)
                                        .foregroundColor(.white.opacity(0.4))
                                }
                                .padding(.horizontal, 30)
                            }
                        }
                    }
                    .padding(.bottom, 20)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        StrokedText(text: "Preparation", size: 24, lineWidth: 8)
                            .padding(.horizontal, 20)
                        
                        ForEach(coffee.preparationSteps, id: \.order) { step in
                            HStack(alignment: .top) {
                                Text("\(step.order).")
                                    .customFont(.customBold, size: 16)
                                    .foregroundColor(.white)
                                    .frame(width: 25, alignment: .leading)
                                
                                Text(step.description)
                                    .customFont(.customRegular, size: 16)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(.horizontal, 30)
                            .padding(.bottom, 5)
                        }
                    }
                    .padding(.bottom, 20)
                    
                    CustomButton(text: "DRINK", style: .red) {
                        viewModel.drinkCoffee(coffee: coffee)
                        
                        withAnimation {
                            isPresented = false
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 80)
                    .frame(maxWidth: .infinity)
                    .opacity(coffee.isAvailable ? 1.0 : 0.5)
                    .disabled(!coffee.isAvailable)
                    .overlay(
                        Group {
                            if !coffee.isAvailable {
                                Text("Missing ingredients to prepare")
                                    .customFont(.customRegular, size: 14)
                                    .foregroundColor(.red.opacity(0.9))
                                    .padding(.top, 50)
                            }
                        }
                    )
                }
                .padding(.top, 80)
            }
            .edgesIgnoringSafeArea(.horizontal)
            
            VStack {
                HStack {
                    BackButton {
                        withAnimation {
                            isPresented = false
                        }
                    }
                    .padding(.leading, 20)
                    
                    Spacer()
                }
                .padding(.top)
                
                Spacer()
            }
        }
        .onAppear {
            print("RecipeView appeared for coffee: \(coffee.name)")
        }
    }
}

struct BackButton: View {
    var action: () -> Void
    
    var body: some View {
        ZStack {
            Capsule()
                .fill(Color(red: 235/255, green: 160/255, blue: 66/255))
                .frame(width: 70, height: 40)
                .overlay(
                    Capsule()
                        .stroke(Color.white, lineWidth: 2)
                )
                .shadow(color: Color(red: 218/255, green: 206/255, blue: 206/255), radius: 0, y: 2)
            
            Image(systemName: "arrow.left")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
        }
        .onTapGesture {
            action()
        }
    }
}

#Preview {
    RecipeView(
        isPresented: .constant(true),
        coffee: Coffee.create(type: .cappuccino)
    )
    .background(
        Image("homeBackground")
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.customOrange)
    )
} 
