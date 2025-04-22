import Foundation
import SwiftUI
import Combine
import FirebaseAuth

// MARK: - Auth ViewModel
final class AuthViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var isRegistrationMode: Bool = false
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var nameError: String = ""
    @Published var emailError: String = ""
    @Published var passwordError: String = ""
    @Published var confirmPasswordError: String = ""
    @Published var formError: String = ""
    
    @Published var isLoading: Bool = false
    @Published var shouldNavigateToPreOnboarding: Bool = false
    
    var navigateToPreOnboarding: (() -> Void)?
    var navigateToAuth: (() -> Void)?
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init() {
        setupValidation()
        if let currentUser = Auth.auth().currentUser {
            print("User already authorized: \(currentUser.uid)")
        }
    }
    
    // MARK: - Private Methods
    private func setupValidation() {
        $email
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] email in
                self?.validateEmail(email)
            }
            .store(in: &cancellables)
        
        $password
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] password in
                self?.validatePassword(password)
            }
            .store(in: &cancellables)
    }
    
    private func validateEmail(_ email: String) {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        emailError = emailPredicate.evaluate(with: email) || email.isEmpty ? "" : "Invalid email"
    }
    
    private func validatePassword(_ password: String) {
        passwordError = password.count >= 6 || password.isEmpty ? "" : "Password must be at least 6 characters"
    }
    
    private func validateForm() -> Bool {
        clearErrors()
        var isValid = true
        
        if email.isEmpty {
            emailError = "Email field cannot be empty"
            isValid = false
        } else {
            validateEmail(email)
            if !emailError.isEmpty {
                isValid = false
            }
        }
        
        if password.isEmpty {
            passwordError = "Password field cannot be empty"
            isValid = false
        } else {
            validatePassword(password)
            if !passwordError.isEmpty {
                isValid = false
            }
        }
        
        if isRegistrationMode {
            if name.isEmpty {
                nameError = "Name field cannot be empty"
                isValid = false
            }
            
            if confirmPassword.isEmpty {
                confirmPasswordError = "Confirm password field cannot be empty"
                isValid = false
            } else if password != confirmPassword {
                confirmPasswordError = "Passwords do not match"
                isValid = false
            }
        }
        
        return isValid
    }
    
    private func clearErrors() {
        nameError = ""
        emailError = ""
        passwordError = ""
        confirmPasswordError = ""
        formError = ""
    }
    
    private func handleRegistration() {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error as NSError? {
                    self.handleAuthError(error)
                    return
                }
                
                guard let user = authResult?.user else {
                    self.formError = "Failed to get user data"
                    return
                }
                
                self.updateUserProfile()
                self.navigateToPreOnboarding?()
            }
        }
    }
    
    private func handleLogin() {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error as NSError? {
                    self.handleAuthError(error)
                    return
                }
                
                guard authResult?.user != nil else {
                    self.formError = "Failed to get user data"
                    return
                }
                
                self.navigateToPreOnboarding?()
            }
        }
    }
    
    private func handleAuthError(_ error: NSError) {
        switch error.code {
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            formError = "This email is already in use"
        case AuthErrorCode.userNotFound.rawValue:
            formError = "User not found"
        case AuthErrorCode.wrongPassword.rawValue:
            formError = "Invalid password"
        case AuthErrorCode.invalidEmail.rawValue:
            formError = "Invalid email"
        case AuthErrorCode.weakPassword.rawValue:
            formError = "Weak password"
        case AuthErrorCode.userDisabled.rawValue:
            formError = "User is disabled"
        default:
            formError = "Authentication error: \(error.localizedDescription)"
        }
    }
    
    private func updateUserProfile() {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges { [weak self] error in
            if let error = error {
                assertionFailure("Profile update error: \(error.localizedDescription)")
            }
        }
    }
    
    private func clearUserData() {
        name = ""
        email = ""
        password = ""
        confirmPassword = ""
        clearErrors()
        isRegistrationMode = false
    }
    
    // MARK: - Public Methods
    func toggleRegistrationMode() {
        withAnimation(.easeInOut(duration: 0.5)) {
            isRegistrationMode.toggle()
            if !isRegistrationMode {
                name = ""
                confirmPassword = ""
            }
            clearErrors()
        }
    }
    
    func authenticate() {
        guard validateForm() else { return }
        
        isLoading = true
        formError = ""
        
        if isRegistrationMode {
            handleRegistration()
        } else {
            handleLogin()
        }
    }
    
    func loginAnonymously() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.navigateToPreOnboarding?()
        }
    }
    
    func signOut() {
        isLoading = true
        
        do {
            try Auth.auth().signOut()
            print("User signed out")
            
            DispatchQueue.main.async {
                self.isLoading = false
                self.clearUserData()
                
                withAnimation {
                    self.navigateToAuth?()
                }
            }
        } catch {
            print("Error signing out: \(error.localizedDescription)")
            
            DispatchQueue.main.async {
                self.isLoading = false
                self.formError = "Error signing out"
            }
        }
    }
    
    static func signOutUser(completion: (() -> Void)? = nil) {
        do {
            try Auth.auth().signOut()
            print("User signed out (static method)")
            completion?()
        } catch {
            print("Error signing out (static method): \(error.localizedDescription)")
        }
    }
    
    func handleAuthAction() {
        authenticate()
    }
} 
