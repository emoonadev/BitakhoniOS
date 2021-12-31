//
//  BTError.swift
//  Bitakhon iOS
//
//  Created by Mickael Belhassen on 05/12/2021.
//

import Foundation

enum BTError: LocalizedError {
	case invalidEndpoint

	public var errorDescription: String? {
		switch self {
			case .invalidEndpoint: return "Invalid endpoint"
		}
	}

	public var failureReason: String? {
		switch self {
			case .invalidEndpoint: return "Invalid endpoint"
		}
	}

	public var recoverySuggestion: String? {
		switch self {
			case .invalidEndpoint: return "Invalid endpoint"
		}
	}
}
