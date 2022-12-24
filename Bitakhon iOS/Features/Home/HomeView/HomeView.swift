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
            )

            Spacer()
        }
                .padding()
                .onAppear {
                    viewModel.checkLocationPermissionAndActiveEmergencies()
                }.handleNavigation($viewModel.navigationDirection).doneAlert(item: $viewModel.currentError)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
