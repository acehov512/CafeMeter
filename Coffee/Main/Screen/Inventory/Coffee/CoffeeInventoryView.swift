import SwiftUI

struct CoffeeInventoryView: View {
    var namespace: Namespace.ID
    @StateObject private var viewModel = CoffeeInventoryViewModel()
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        VStack(spacing: 40) {
            StrokedText(text: viewModel.title, size: 36, lineWidth: 15)
                .padding()
            
            ScrollView {
                VStack(spacing: 4) {
                    ForEach(viewModel.coffeeItems) { item in
                        CoffeeItemCell(
                            title: item.name,
                            isSelected: item.isSelected
                        ) {
                            viewModel.toggleSelection(for: item)
                        }
                    }
                }
            }
            
            Spacer()
        }
        .overlay(
            VStack {
                HStack {
                    CustomButton(text: "←", style: .orange, height: 40) {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding(.top, 5)
                    .frame(width: 70)
                    
                    Spacer()
                }
                .padding()
                
                Spacer()
            },
            alignment: .topLeading
        )
        .background(
            Image("homeBackground")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.customOrange)
        )
    }
}

// MARK: - Preview
struct CoffeeInventoryViewPreview: View {
    @Namespace var namespace
    
    var body: some View {
        CoffeeInventoryView(namespace: namespace)
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
    CoffeeInventoryViewPreview()
} 
