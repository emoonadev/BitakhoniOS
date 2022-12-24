//
// Created by Mickael Belhassen on 31/12/2021.
//

import SwiftUI

enum OnboardingFlowDestination: RouteCoordinator {
    case login
    case home

    var view: some View {
        switch self {
            case .login:
                return AnyView(LoginView())
            case .home:
                return AnyView(HomeView())
        }
    }
}
