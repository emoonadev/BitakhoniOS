//
//  Textfield+Style.swift
//  Bitakhon iOS
//
//  Created by Mickael Belhassen on 03/12/2021.
//

import SwiftUI

struct PrimaryTextField: TextFieldStyle {
	func _body(configuration: TextField<Self._Label>) -> some View {
		configuration
			.textFieldStyle(.roundedBorder)
	}
}

extension TextFieldStyle where Self == PrimaryTextField {
	static var primaryTextField: PrimaryTextField { PrimaryTextField() }
}
