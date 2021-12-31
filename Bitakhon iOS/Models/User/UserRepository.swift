//
//  UserRepository.swift
//  Bitakhon iOS
//
//  Created by Mickael Belhassen on 05/12/2021.
//

import Foundation

protocol UserRepositoryService {
	func createUser(email: String, password: String) async throws
	func logUser(email: String, password: String) async throws 
}

final class UserRepository: UserRepositoryService {
	let apiClient: APIClientService

	init(apiClient: APIClientService) {
		self.apiClient = apiClient
	}
}

// MARK: - CRUD

extension UserRepository {
	
	func createUser(email: String, password: String) async throws {
		let loginRes: LoginRes = try await apiClient.perform(.createUser(.init(email: email, fullName: "", password: password, loginMethod: .email)))
	}

	func logUser(email: String, password: String) async throws {
		try await apiClient.perform(.loginUser(email: email, password: password))
	}
}
