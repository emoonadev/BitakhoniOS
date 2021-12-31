//
//  SignStatus.swift
//  Bitakhon iOS
//
//  Created by Mickael Belhassen on 03/12/2021.
//

import Foundation

enum SignStatus: Int, Codable {
	case login = 0, register = 1
	
	var title: String {
		switch self {
			case .login: return "Login"
			case .register: return "Register"
		}
	}
}
