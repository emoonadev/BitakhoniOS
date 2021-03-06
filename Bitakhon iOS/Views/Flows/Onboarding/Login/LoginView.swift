//
//  LoginView.swift
//  Bitakhon iOS
//
//  Created by Mickael Belhassen on 03/12/2021.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObservedResolve var viewModel: LoginViewModel

    // MARK: View properties

    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isAlertPresented = false

    // MARK: View

    var body: some View {
        VStack {
            Spacer()

            BTTextField(placeholder: "Email or phone number", text: $username)
                    .keyboardType(.emailAddress)
					.backport.neverAutocapitalization()

            BTSecureField(placeholder: "Password", text: $password)
            Button(viewModel.signStatus.title) {
                viewModel.logUser(with: username, password: password)
            }

            Spacer()

            Button(viewModel.switchSignStatusTitle) {
                viewModel.toggleSignStatus()
            }
                    .doneAlert(item: $viewModel.currentError)
                    .handleNavigation($viewModel.navigationDirection)
        }
                .padding()
    }
}

// MARK: - Preview

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
