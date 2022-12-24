//
//  EmergencyView.swift
//  Bitakhon iOS
//
//  Created by Mickael Belhassen on 09/01/2022.
//
//

import SwiftUI

struct EmergencyView: View {

    @EnvironmentObservedResolve var viewModel: EmergencyViewModel


    var body: some View {
        VStack {
            Button(
                    action: {
                        viewModel.resolveEmergency(status: .resolved)
                    },
                    label: {
                        Text("Resolve emergency")
                    }
            )
            Button(
                    action: {
                        viewModel.resolveEmergency(status: .canceled)
                    },
                    label: {
                        Text("Cancel emergency")
                    }
            )
        }.handleNavigation($viewModel.navigationDirection)
                .doneAlert(item: $viewModel.currentError)
    }
}

struct EmergencyView_Previews: PreviewProvider {
    static var previews: some View {
        EmergencyView()
    }
}
