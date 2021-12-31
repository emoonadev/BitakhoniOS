//
//  BT+DictionaryEncoder.swift.swift
//  Bitakhon iOS
//
//  Created by Mickael Belhassen on 05/12/2021.
//

import Foundation

struct DictionaryEncoder {

	static func encode<T>(_ value: T) throws -> [String: Any] where T: Encodable {
		let jsonData = try JSONEncoder().encode(value)
		return try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] ?? [:]
	}

}
