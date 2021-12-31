//
//  ServerResponse.swift
//  Bitakhon iOS
//
//  Created by Mickael Belhassen on 05/12/2021.
//

import Foundation

struct ServerResponse<T: Codable>: ServerResponseModel, Codable {
	let code: Int
	let message: String
	let data: T?
}

struct Nothing: Codable {}
