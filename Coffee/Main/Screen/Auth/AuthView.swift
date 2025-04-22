import SwiftUI

// MARK: - Views
struct AuthView: View {
    var namespace: Namespace.ID
    @StateObject private var viewModel = AuthViewModel()
    @EnvironmentObject private var coordinator: MainCoordinator
    
    private let textFieldColor = Color(red: 249/255, green: 197/255, blue: 133/255)
    private let strokeColor = Color(red: 228/255, green: 167/255, blue: 91/255)
    private let titleColor = Color(red: 209/255, green: 133/255, blue: 39/255, opacity: 1)
    
    var body: some View {
        VStack {
            formView
            actionButton
            Spacer()
            bottomView
        }
        .onAppear(perform: setupView)
    }
    
    private var formView: some View {
        VStack {
            Text(viewModel.isRegistrationMode ? "Registration" : "Log in")
                .foregroundColor(.white)
                .customFont(.customExtraBold, size: 38)
                .padding(.bottom)
                .animation(.easeInOut, value: viewModel.isRegistrationMode)
            
            if viewModel.isRegistrationMode {
                customTextField(
                    text: $viewModel.name,
                    placeholder: "Name",
                    error: viewModel.nameError
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .top).combined(with: .opacity),
                    removal: .move(edge: .top).combined(with: .opacity)
                ))
            }
            
            customTextField(
                text: $viewModel.email,
                placeholder: "Email",
                error: viewModel.emailError,
                keyboardType: .emailAddress,
                textInputAutocapitalization: .never,
                disableAutocorrection: true
            )
            
            customSecureField(
                text: $viewModel.password,
                placeholder: "Password",
                error: viewModel.passwordError
            )
            
            if viewModel.isRegistrationMode {
                customSecureField(
                    text: $viewModel.confirmPassword,
                    placeholder: "Confirm password",
                    error: viewModel.confirmPasswordError
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .move(edge: .bottom).combined(with: .opacity)
                ))
            }
            
            if !viewModel.formError.isEmpty {
                Text(viewModel.formError)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.top, 5)
            }
        }
        .padding(.vertical, 30)
        .background(
            Color.customOrange
                .cornerRadius(40)
                .matchedGeometryEffect(id: "orangeRectangle", in: namespace)
        )
        .padding(.horizontal, 10)
        .animation(.easeInOut(duration: 0.3), value: viewModel.isRegistrationMode)
    }
    
    private var actionButton: some View {
        CustomButton(
            text: viewModel.isRegistrationMode ? "REGISTRATION" : "LOG IN",
            style: .red
        ) {
            viewModel.handleAuthAction()
        }
        .padding(.top, 20)
        .padding(.horizontal, 10)
        .animation(.easeInOut, value: viewModel.isRegistrationMode)
        .matchedGeometryEffect(id: "actionButton", in: namespace)
        .disabled(viewModel.isLoading)
        .overlay(
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
            }
        )
    }
    
    private var bottomView: some View {
        VStack {
            Text("You can choose another way")
                .customFont(.customRegular, size: 22)
                .foregroundColor(titleColor)
            
            CustomButton(
                text: viewModel.isRegistrationMode ? "LOG IN" : "REGISTRATION",
                style: .orange
            ) {
                viewModel.toggleRegistrationMode()
            }
            
            CustomButton(text: "ANONIMOUS", style: .orange) {
                viewModel.loginAnonymously()
            }
        }
        .padding(.horizontal, 10)
        .padding(.bottom)
    }
    
    private func customTextField(
        text: Binding<String>,
        placeholder: String,
        error: String,
        keyboardType: UIKeyboardType = .default,
        textInputAutocapitalization: TextInputAutocapitalization = .sentences,
        disableAutocorrection: Bool = false
    ) -> some View {
        TextField("", text: text)
            .foregroundColor(textFieldColor)
            .placeholder(when: text.wrappedValue.isEmpty) {
                Text(placeholder)
                    .foregroundColor(textFieldColor)
            }
            .keyboardType(keyboardType)
            .textInputAutocapitalization(textInputAutocapitalization)
            .disableAutocorrection(disableAutocorrection)
            .textFieldStyle()
            .overlay(errorView(error))
    }
    
    private func customSecureField(
        text: Binding<String>,
        placeholder: String,
        error: String
    ) -> some View {
        SecureField("", text: text)
            .foregroundColor(textFieldColor)
            .placeholder(when: text.wrappedValue.isEmpty) {
                Text(placeholder)
                    .foregroundColor(textFieldColor)
            }
            .textFieldStyle()
            .overlay(errorView(error))
    }
    
    private func errorView(_ error: String) -> some View {
        Text(error)
            .foregroundColor(.red)
            .font(.caption)
            .padding(.horizontal, 25)
            .padding(.top, 60)
    }
    
    private func setupView() {
        viewModel.navigateToPreOnboarding = { [weak coordinator] in
            withAnimation {
                coordinator?.navigate(to: .preOnboarding)
            }
        }
        
        viewModel.navigateToAuth = { [weak coordinator] in
            withAnimation {
                coordinator?.navigate(to: .auth)
            }
        }
    }
}

// MARK: - Extensions
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
    
    func textFieldStyle() -> some View {
        self
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color(red: 228/255, green: 167/255, blue: 91/255), lineWidth: 2)
            )
            .padding(.horizontal, 20)
    }
}

#Preview {
    AuthView(namespace: Namespace().wrappedValue)
        .environmentObject(MainCoordinator())
}
