//
//  BT+MainTextField.swift
//  Bitakhon iOS
//
//  Created by Mickael Belhassen on 03/12/2021.
//

import SwiftUI

struct BTTextField: View {
	var placeholder = ""
	@Binding var text: String

	var body: some View {
		TextField(placeholder, text: $text)
			.textFieldStyle(.primaryTextField)
	}
}
