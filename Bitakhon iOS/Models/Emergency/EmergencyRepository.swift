//
// Created by Mickael Belhassen on 03/01/2022.
//

import Foundation

protocol EmergencyRepositoryService {
    func createOrUpdate(coordinate: BTCLLocationCoordinate2D, status: Emergency.Status) async throws -> Emergency
    func getActiveEmergencies() async throws -> [Emergency]
}

class EmergencyRepository: EmergencyRepositoryService {

    let apiClient: APIClientService

    init(apiClient: APIClientService) {
        self.apiClient = apiClient
    }

}


// MARK: - CRUD

extension EmergencyRepository {

    func createOrUpdate(coordinate: BTCLLocationCoordinate2D, status: Emergency.Status) async throws -> Emergency {
        let res: CreateOrUpdateEmergencyRes = try await apiClient.perform(.createEmergency(.init(status: status, location: coordinate)))
        return res.emergency
    }

    func getActiveEmergencies() async throws -> [Emergency] {
        try await apiClient.perform(.getActiveEmergencies) as [Emergency]
    }

}