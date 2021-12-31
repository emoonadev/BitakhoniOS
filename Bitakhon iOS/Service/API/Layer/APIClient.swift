//
//  APIClient.swift
//  Bitakhon iOS
//
//  Created by Mickael Belhassen on 05/12/2021.
//

import Foundation

protocol APIClientService {
	func perform<T: Codable>(_ route: APIConstants.Route) async throws -> T
	func perform(_ route: APIConstants.Route) async throws
}

final class APIClient: APIClientService {
	let queue = OperationQueue()
	let networking: NetworkingService = Networking()
}

// MARK: -

extension APIClient {
	func perform(_ route: APIConstants.Route) async throws {
		let _: Nothing = try await perform(route)
	}
	
	func perform<T: Codable>(_ route: APIConstants.Route) async throws -> T {
		// TODO check token expiration before send request and pause queue if needed until new token get
		return try await withCheckedThrowingContinuation { continuation in
			let req = route.request

			queue.addOperation {
				self.networking.request(url: req.url, method: req.method, headers: req.headers, body: req.body) { (response: URLResponse?, result: Result<ServerResponse<T>, Error>) in
					switch result {
						case .success(let response):
							if let data = response.data {
								continuation.resume(returning: data)
							} else if let data = () as? T {
								continuation.resume(returning: data)
							}
						case .failure(let error):
							continuation.resume(throwing: error)
					}
				}
			}
		}
	}
}
