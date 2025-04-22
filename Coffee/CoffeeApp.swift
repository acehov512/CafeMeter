import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    
    Auth.auth().addStateDidChangeListener { auth, user in
      if let user = user {
        print("User authorized: \(user.uid), email: \(user.email ?? "no email")")
      } else {
        print("User not authorized")
      }
    }

    return true
  }
}

@main
struct CoffeeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            CoordinatorView()
        }
    }
}
