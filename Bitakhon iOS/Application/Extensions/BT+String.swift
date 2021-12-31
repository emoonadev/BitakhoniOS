//
//  BT+String.swift
//  Bitakhon iOS
//
//  Created by Mickael Belhassen on 12/12/2021.
//

import Foundation

extension String {

	private func checkEmail() -> Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

		let email = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
		return email.evaluate(with: self)
	}

	var isEmail: Bool {
		get {
			return checkEmail()
		}
	}

}
