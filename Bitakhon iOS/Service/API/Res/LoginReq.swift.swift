//
//  LoginReq.swift.swift
//  Bitakhon iOS
//
//  Created by Mickael Belhassen on 05/12/2021.
//

import Foundation

struct LoginReq: Codable {
	let email: String
	let fullName: String?
	let password: String
	let loginMethod: LoginMethod
}
