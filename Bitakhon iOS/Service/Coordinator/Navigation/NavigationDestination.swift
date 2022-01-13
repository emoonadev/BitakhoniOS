//
// Created by Mickael Belhassen on 31/12/2021.
//

import SwiftUI

enum NavigationDestination {
    case login
    case home
    case emergency(emergency: Emergency)

    var view: some View {
        switch self {
            case .login:
                return AnyView(LoginView())
            case .home:
                return AnyView(HomeView())
            case .emergency(let emergency):
                let view = EmergencyView()
                view.viewModel.emergency = emergency
                return AnyView(view)
        }
    }
}
