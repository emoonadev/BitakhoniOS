//
//  HomeFlowCoordinator.swift
//  Bitakhon iOS
//
//  Created by Mickael Belhassen on 24/12/2022.
//

import SwiftUI
enum HomeFlowDestination: RouteCoordinator {
    case emergency(emergency: Emergency)

    var view: some View {
        switch self {
            case .emergency(let emergency):
                let view = EmergencyView()
                view.viewModel.emergency = emergency
                return AnyView(view)
        }
    }
}
