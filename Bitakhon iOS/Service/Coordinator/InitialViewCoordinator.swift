//
// Created by Mickael Belhassen on 31/12/2021.
//

import SwiftUI

class InitialViewCoordinator {

    private let userRepository: UserRepositoryService


    init(userRepository: UserRepositoryService) {
        self.userRepository = userRepository
    }

}


// MARK: Initial view

extension InitialViewCoordinator {

    func initialView() -> some View {
        userRepository.user == nil ? NavigationDestination.login.view : NavigationDestination.home.view
    }

}
