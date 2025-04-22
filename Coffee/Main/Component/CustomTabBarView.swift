import SwiftUI

// MARK: - Models
enum Tab: CaseIterable {
    case home
    case random
    case recipes
    case inventory
    case profile
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .random: return "Random"
        case .recipes: return "Recipes"
        case .inventory: return "Inventory"
        case .profile: return "Profile"
        }
    }
    
    var iconName: String {
        switch self {
        case .home: return "home"
        case .random: return "random"
        case .recipes: return "recipes"
        case .inventory: return "inventory"
        case .profile: return "profile"
        }
    }
}

// MARK: - Views
struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    @Namespace private var animationNamespace
    
    private let tabBarBackground = Color(red: 245/255, green: 218/255, blue: 146/255)
    private let tabBarSlider = Color(red: 255/255, green: 255/255, blue: 187/255)
    private let tabBarTextColor = Color(red: 152/255, green: 107/255, blue: 51/255)
    private let tabs: [Tab] = Tab.allCases
    
    var body: some View {
        ZStack {
            tabBarBackground
                .ignoresSafeArea(.container, edges: .bottom)

            ZStack(alignment: .leading) {
                sliderView
                tabButtonsView
            }
        }
        .frame(height: 60)
    }
    
    private var sliderView: some View {
        Group {
            if let index = tabs.firstIndex(of: selectedTab) {
                GeometryReader { geometry in
                    tabBarSlider
                        .frame(width: geometry.size.width / CGFloat(tabs.count), height: 80)
                        .cornerRadius(20)
                        .offset(x: geometry.size.width / CGFloat(tabs.count) * CGFloat(index))
                        .matchedGeometryEffect(id: "TabHighlight", in: animationNamespace)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab)
                }
                .frame(height: 80)
            }
        }
    }
    
    private var tabButtonsView: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                TabButton(
                    tab: tab,
                    selectedTab: $selectedTab,
                    namespace: animationNamespace,
                    textColor: tabBarTextColor
                )
            }
        }
        .padding(.vertical, 16)
    }
}

private struct TabButton: View {
    let tab: Tab
    @Binding var selectedTab: Tab
    var namespace: Namespace.ID
    var textColor: Color
    
    var body: some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 8) {
                Image(tab.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                
                Text(tab.title)
                    .customFont(.customRegular, size: 14)
                    .foregroundColor(textColor)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.home))
    }
    .background(Color.gray)
}
