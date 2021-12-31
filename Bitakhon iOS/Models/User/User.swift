//
//  User.swift
//  Bitakhon iOS
//
//  Created by Mickael Belhassen on 05/12/2021.
//

import Foundation

struct User: Codable {
	var id: UUID
	var email: String
	var fullName: String?
	var loginMethod: LoginMethod
}
