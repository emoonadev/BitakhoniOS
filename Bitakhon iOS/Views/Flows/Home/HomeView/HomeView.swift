//
//  HomeView.swift
//  Bitakhon iOS
//
//  Created by Mickael Belhassen on 31/12/2021.
//
//

import SwiftUI

struct HomeView: View {

    @EnvironmentObservedResolve var viewModel: HomeViewModel

    // MARK: Properties

    // MARK: - View

    var body: some View {
        VStack {
            Button(
                    action: {
                        viewModel.createEmergency()
                    },
                    label: {
                        Text("Start emergency")
                    }
            ).doneAlert(item: $viewModel.currentError)
        }.onAppear {
            viewModel.checkLocationPermissionAndActiveEmergencies()
        }.handleNavigation($viewModel.navigationDirection)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
