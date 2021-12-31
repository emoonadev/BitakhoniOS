//
//  BTSecureField.swift.swift
//  Bitakhon iOS
//
//  Created by Mickael Belhassen on 12/12/2021.
//

import SwiftUI

struct BTSecureField: View {
	var placeholder = ""
	@Binding var text: String

	var body: some View {
		SecureField("Password", text: $text)
			.textFieldStyle(.primaryTextField)
	}
}
