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

	@State private var username: String = "bitakhon@gmail.com"
	@State private var password: String = "capoeira"
	@State private var isAlertPresented = false

	// MARK: View

	var body: some View {
		VStack {
			Spacer()

			BTTextField(placeholder: "Email or phone number", text: $username)
			BTSecureField(placeholder: "Password", text: $password)

			Button(viewModel.signStatus.title) {
				viewModel.logUser(with: username, password: password)
			}

			Spacer()

			Button(viewModel.switchSignStatusTitle) {
				viewModel.toggleSignStatus()
			}
			.doneAlert(item: $viewModel.currentError)
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
