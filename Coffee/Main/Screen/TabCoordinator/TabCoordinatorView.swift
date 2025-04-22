import SwiftUI

class TabCoordinator: ObservableObject {
    @Published var selectedTab: Tab = .home
    
    func switchTab(to tab: Tab) {
        selectedTab = tab
    }
}

struct TabCoordinatorView: View {
    @StateObject private var tabCoordinator = TabCoordinator()
    @Namespace private var namespace
    @EnvironmentObject private var mainCoordinator: MainCoordinator
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                TabView(selection: $tabCoordinator.selectedTab) {
                    HomeView(namespace: namespace)
                        .environmentObject(mainCoordinator)
                        .tag(Tab.home)
                    
                    RandomView(namespace: namespace)
                        .environmentObject(mainCoordinator)
                        .tag(Tab.random)
                    
                    RecipesView(namespace: namespace)
                        .environmentObject(mainCoordinator)
                        .tag(Tab.recipes)
                    
                    InventoryView(namespace: namespace)
                        .environmentObject(mainCoordinator)
                        .tag(Tab.inventory)
                    
                    ProfileView(namespace: namespace)
                        .environmentObject(mainCoordinator)
                        .tag(Tab.profile)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                CustomTabBar(selectedTab: $tabCoordinator.selectedTab)
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    TabCoordinatorView()
        .environmentObject(MainCoordinator())
} 
