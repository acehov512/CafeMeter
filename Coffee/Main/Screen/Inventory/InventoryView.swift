import SwiftUI

struct InventoryView: View {
    var namespace: Namespace.ID
    @StateObject private var viewModel = InventoryViewModel()
    @EnvironmentObject private var coordinator: MainCoordinator
    @State private var showCoffeeInventory = false
    @State private var showSyrupsInventory = false
    @State private var showOptionalsInventory = false
    @State private var showDrinksInventory = false
    
    var body: some View {
        VStack {
            StrokedText(text: viewModel.title, size: 48, lineWidth: 15)
                .padding()
            
            let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

            LazyVGrid(columns: columns, spacing: 5) {
                Button {
                    showCoffeeInventory = true
                } label: {
                    Image("coffeeInventory")
                        .resizable()
                        .scaledToFit()
                }
                
                Button {
                    showSyrupsInventory = true
                } label: {
                    Image("syrupsInventory")
                        .resizable()
                        .scaledToFit()
                }
                
                Button {
                    showOptionalsInventory = true
                } label: {
                    Image("optionalsInventory")
                        .resizable()
                        .scaledToFit()
                }
                
                Button {
                    showDrinksInventory = true
                } label: {
                    Image("drinksInventory")
                        .resizable()
                        .scaledToFit()
                }
            }
            .padding(.horizontal) 

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            viewModel.loadData()
        }
        .fullScreenCover(isPresented: $showCoffeeInventory) {
            CoffeeInventoryView(namespace: namespace)
        }
        .fullScreenCover(isPresented: $showSyrupsInventory) {
            SyrupsInventoryView(namespace: namespace)
        }
        .fullScreenCover(isPresented: $showOptionalsInventory) {
            OptionalsInventoryView(namespace: namespace)
        }
        .fullScreenCover(isPresented: $showDrinksInventory) {
            DrinksInventoryView(namespace: namespace)
        }
    }
}

struct InventoryViewPreview: View {
    @Namespace var namespace
    
    var body: some View {
        InventoryView(namespace: namespace)
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
    InventoryViewPreview()
} 
