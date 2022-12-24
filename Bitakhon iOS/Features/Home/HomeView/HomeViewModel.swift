//
// Created by Mickael Belhassen on 03/01/2022.
//

import Foundation

class HomeViewModel: ObservableObject {

    let locationManager: LocationManagerService
    let emergencyRepository: EmergencyRepositoryService

    // MARK: Properties

    @Published var currentError: ErrorInfo?
    @Published var isLoading: Bool = false
    @Published var navigationDirection: NavigationDirection?


    init(locationManager: LocationManagerService, emergencyRepository: EmergencyRepositoryService) {
        self.locationManager = locationManager
        self.emergencyRepository = emergencyRepository
    }

}


// MARK: - Formatted data

extension HomeViewModel {}


// MARK: - View interactions

@MainActor extension HomeViewModel {
    func createEmergency() {
        Task {
            isLoading = true

            let coordinate = await locationManager.getCurrentCoordinate()

            do {
                let emergency = try await emergencyRepository.createOrUpdate(coordinate: coordinate, status: .opened)
                navigationDirection = .forward(destination: .emergency(emergency: emergency), style: .fullScreenCover)
            } catch {
                currentError = .init(description: error.localizedDescription)
            }

            isLoading = false
        }
    }

    func checkLocationPermissionAndActiveEmergencies() {
        checkActiveEmergencies()
        checkLocationAuthorizationAndOpenPermissionFlowIfNeeded()
    }

    func checkActiveEmergencies() {
        Task {
            if let emergencies = try? await emergencyRepository.getActiveEmergencies(), let emergency = emergencies.first {
                navigationDirection = .forward(destination: .emergency(emergency: emergency), style: .fullScreenCover)
            }
        }
    }

    func checkLocationAuthorizationAndOpenPermissionFlowIfNeeded() {
        locationManager.requestLocationPermissionIfNeeded()
    }
}