import SwiftUI
import Combine
import PhotosUI
import FirebaseAuth

// MARK: - Profile ViewModel
class ProfileViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var title = "Profile"
    @Published var userName = "Anonymous"
    @Published var useremail = "email@example.com"
    @Published var isAuthenticated = false
    
    @Published var selectedItem: PhotosPickerItem? = nil
    @Published var profileImage: Image? = nil
    
    private var authStateListener: AuthStateDidChangeListenerHandle?
    
    var coordinator: MainCoordinator?
    
    // MARK: - Initializer
    init() {
        setupAuthStateListener()
    }
    
    deinit {
        if let authStateListener = authStateListener {
            Auth.auth().removeStateDidChangeListener(authStateListener)
        }
    }
    
    // MARK: - Private Methods
    private func setupAuthStateListener() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.updateUserInfo(user: user)
            }
        }
    }
    
    private func updateUserInfo(user: User?) {
        if let user = user {
            isAuthenticated = true
            userName = user.displayName ?? "User"
            useremail = user.email ?? "no email"
            
            if user.isAnonymous {
                userName = "Anonymous User"
            }
            
            print("User authorized: \(user.uid)")
        } else {
            isAuthenticated = false
            userName = "Anonymous"
            useremail = "email@example.com"
            print("User not authorized")
        }
    }
    
    // MARK: - Public Methods
    func loadData() {
        updateUserInfo(user: Auth.auth().currentUser)
    }
    
    func signOut() {
        if let coordinator = coordinator {
            coordinator.signOut()
        } else {
            AuthViewModel.signOutUser()
        }
    }
    
    func deleteAccount() {
        guard let user = Auth.auth().currentUser else { return }
        
        user.delete { [weak self] error in
            if let error = error {
                print("Error deleting account: \(error.localizedDescription)")
            } else {
                print("Account successfully deleted")
            }
        }
    }
    
    @MainActor
    func loadImage(from item: PhotosPickerItem?) async {
        guard let item = item else { return }
        
        do {
            let data = try await item.loadTransferable(type: Data.self)
            if let data = data, let uiImage = UIImage(data: data) {
                self.profileImage = Image(uiImage: uiImage)
            } else {
                print("Could not load image data")
                self.profileImage = nil
            }
        } catch {
            print("Error loading image: \(error)")
            self.profileImage = nil
        }
    }
} 
