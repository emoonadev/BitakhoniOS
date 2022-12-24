//
//  LoginViewModel.swift
//  Bitakhon iOS
//
//  Created by Mickael Belhassen on 03/12/2021.
//

import Foundation

class LoginViewModel: ObservableObject {

    let userRepository: UserRepositoryService

    // MARK: Properties

    @Published var signStatus: SignStatus = .login
    @Published var currentError: ErrorInfo?
    @Published var navigationDirection: NavigationDirection<OnboardingFlowDestination>?


    init(userRepository: UserRepositoryService) {
        self.userRepository = userRepository
    }

}


// MARK: - Formatted Data

extension LoginViewModel {

    var switchSignStatusTitle: String { signStatus == .login ? "You not have an account? Click to register" : "Already have an account? Click to login" }

}

// MARK: - View interaction

@MainActor extension LoginViewModel {

    func toggleSignStatus() {
        if signStatus == .login {
            signStatus = .register
        } else {
            signStatus = .login
        }
    }

    func logUser(with email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            currentError = .init(description: "All fields are required")
            return
        }

        guard email.isEmail else {
            currentError = .init(description: "Email not valid")
            return
        }

        Task {
            do {
                if signStatus == .register {
                    try await userRepository.createUser(email: email, password: password)
                } else {
                    try await userRepository.logUser(email: email, password: password)
                }

                navigationDirection = .forward(destination: .home, style: .fullScreenCover)
            } catch {
                currentError = .init(description: error.localizedDescription)
            }
        }
    }

}
