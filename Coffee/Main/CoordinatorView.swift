import SwiftUI
import FirebaseAuth

// MARK: - Navigation
enum Screen {
    case launch
    case welcome
    case auth
    case preOnboarding
    case onboarding
    case postOnboarding
    case tab
}

final class MainCoordinator: ObservableObject {
    @Published var currentScreen: Screen = .launch
    @Published var isUserAuthenticated: Bool = false

    init() {
        currentScreen = .launch
        checkUserAuthState()
        setupAuthStateListener()
    }
    
    private func setupAuthStateListener() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isUserAuthenticated = user != nil
            }
        }
    }
    
    func checkUserAuthState() {
        isUserAuthenticated = Auth.auth().currentUser != nil
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            isUserAuthenticated = false
            navigate(to: .auth)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }

    func navigate(to screen: Screen) {
        if currentScreen != screen {
            withAnimation(.spring(duration: 0.6)) {
                currentScreen = screen
            }
        }
    }
    
    func handleLaunchCompletion() {
        if currentScreen == .launch {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation(.bouncy(duration: 0.3, extraBounce: 0.3)) {
                    self.navigate(to: self.isUserAuthenticated ? .preOnboarding : .welcome)
                }
            }
        }
    }
}

// MARK: - View
struct CoordinatorView: View {
    @StateObject private var coordinator = MainCoordinator()
    @Namespace private var animation
    
    var body: some View {
        NavigationStack {
            Group {
                switch coordinator.currentScreen {
                case .launch:
                    LaunchView(namespace: animation)
                        .onAppear {
                            coordinator.handleLaunchCompletion()
                        }
                        .environmentObject(coordinator)
                case .welcome:
                    WelcomeView(namespace: animation)
                        .environmentObject(coordinator)
                case .auth:
                    AuthView(namespace: animation)
                        .environmentObject(coordinator)
                case .preOnboarding:
                    PreOnboardingView(namespace: animation)
                        .environmentObject(coordinator)
                case .onboarding:
                    OnboardingView(namespace: animation)
                        .environmentObject(coordinator)
                case .postOnboarding:
                    PostOnboardingView(namespace: animation)
                        .environmentObject(coordinator)
                case .tab:
                    TabCoordinatorView()
                        .environmentObject(coordinator)
                }
            }
            .frame(maxWidth: .infinity)
            .background(backgroundView)
        }
        .environmentObject(coordinator)
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        ZStack {
            if coordinator.currentScreen == .tab {
                Color("customOrange")
                Image("homeBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Color("LaunchScreenBackground")
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    CoordinatorView()
}


