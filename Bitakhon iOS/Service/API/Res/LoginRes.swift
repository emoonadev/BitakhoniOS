//
//  LoginRes.swift
//  Bitakhon iOS
//
//  Created by Mickael Belhassen on 05/12/2021.
//

import Foundation

struct LoginRes: Codable {
	let accessToken: String
	let user: User
	let status: SignStatus
}
