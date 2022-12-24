//
// Created by Mickael Belhassen on 09/01/2022.
//

import Foundation

class EmergencyViewModel: ObservableObject {
    let emergencyRepository: EmergencyRepositoryService

    @Published var emergency: Emergency?
    @Published var currentError: ErrorInfo?
    @Published var navigationDirection: NavigationDirection<OnboardingFlowDestination>?


    init(emergencyRepository: EmergencyRepositoryService) {
        self.emergencyRepository = emergencyRepository
    }

}


// MARK: - Actions

extension  EmergencyViewModel {

    func resolveEmergency(status: Emergency.Status) {
        Task {
            do {
                try await emergencyRepository.createOrUpdate(coordinate: .init(latitude: 0, longitude: 0), status: status)
                navigationDirection = .back
            } catch {
                currentError = .init(description: error.localizedDescription)
            }
        }
    }

}
