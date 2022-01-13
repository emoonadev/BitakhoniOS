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

    var user: User? { get }
}

final class UserRepository: UserRepositoryService {

    let apiClient: APIClientService
    var user: User? { UserDefaultsManager.loggedUser }
    var accessToken: String? { KeychainManager.userAccessToken }


    init(apiClient: APIClientService) {
        self.apiClient = apiClient
    }

}


// MARK: - CRUD

extension UserRepository {

    func createUser(email: String, password: String) async throws {
        let loginRes: LoginRes = try await apiClient.perform(.createUser(.init(email: email, fullName: "", password: password, loginMethod: .email)))
        saveUserData(loginRes, password: password)
    }

    func logUser(email: String, password: String) async throws {
        let loginRes: LoginRes = try await apiClient.perform(.loginUser(email: email, password: password))
        saveUserData(loginRes, password: password)
    }

    func saveUserData(_ res: LoginRes, password: String) {
        KeychainManager.userAccessToken = res.accessToken
        KeychainManager.userPassword = password
        UserDefaultsManager.loggedUser = res.user
    }
    
}
