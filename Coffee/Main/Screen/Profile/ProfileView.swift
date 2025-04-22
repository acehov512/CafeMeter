import SwiftUI
import PhotosUI

// MARK: - Profile View
struct ProfileView: View {
    var namespace: Namespace.ID
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject private var coordinator: MainCoordinator
    
    var body: some View {
        ScrollView {
            VStack {
                StrokedText(text: viewModel.title, size: 48, lineWidth: 15)
                    .padding()
                
                PhotosPicker(selection: $viewModel.selectedItem, matching: .images) {
                    Group {
                        if let profileImage = viewModel.profileImage {
                            profileImage
                                .resizable()
                                .scaledToFill()
                        } else {
                            Image("avatar")
                                .resizable()
                                .scaledToFill()
                                .blur(radius: 5)
                        }
                    }
                    .frame(width: 220, height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 40))
                    .overlay(
                        Image(systemName: "camera.circle.fill")
                            .font(.title)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(8)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle()),
                        alignment: .bottomTrailing
                    )
                }
                .onChange(of: viewModel.selectedItem) { newItem in
                    Task {
                        await viewModel.loadImage(from: newItem)
                    }
                }
                
                StrokedText(text: viewModel.userName, size: 46, lineWidth: 15)

                CustomButton(text: "CHANGE MY TASTES", style: .orange) {
                    coordinator.navigate(to: .preOnboarding)
                }
                .padding(.horizontal)
                .padding(.top)
                
                if viewModel.isAuthenticated {
                    StrokedText(text: viewModel.useremail, size: 24, lineWidth: 15)
                        .padding(.vertical, 40)
                }
                
                Spacer()
                
                if viewModel.isAuthenticated {
                    CustomButton(text: "LOG OUT", style: .red) {
                        viewModel.signOut()
                    }
                    .padding(.horizontal)
                    
                    CustomButton(text: "DELETE ACCOUNT", style: .red) {
                        showDeleteConfirmation()
                    }
                    .padding(.horizontal)
                } else {
                    CustomButton(text: "AUTHORIZATION", style: .red) {
                        coordinator.navigate(to: .auth)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 100)
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            viewModel.loadData()
            viewModel.coordinator = coordinator
        }
    }
    
    private func showDeleteConfirmation() {
        let alert = UIAlertController(
            title: "Delete Account",
            message: "Are you sure you want to delete your account? This action cannot be undone.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            viewModel.deleteAccount()
        })
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(alert, animated: true)
        }
    }
}

// MARK: - Preview
struct ProfileViewPreview: View {
    @Namespace var namespace
    
    var body: some View {
        ProfileView(namespace: namespace)
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
    ProfileViewPreview()
} 
