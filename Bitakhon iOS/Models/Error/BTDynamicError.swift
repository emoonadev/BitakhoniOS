//
//  BTDynamicError.swift
//  Bitakhon iOS
//
//  Created by Mickael Belhassen on 05/12/2021.
//

import Foundation

protocol ErrorProtocol: LocalizedError {
	var title: String? { get }
	var code: Int { get }
}

struct BTDynamicError: ErrorProtocol {
	var title: String?
	var code: Int
	var errorDescription: String? { return _description }
	var failureReason: String? { return _description }

	private var _description: String

	init(title: String?, description: String, code: Int) {
		self.title = title ?? "Error"
		self._description = description
		self.code = code
	}
}
