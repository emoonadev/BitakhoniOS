//
//  Bitakhon_iOSApp.swift
//  Bitakhon iOS
//
//  Created by Mickael Belhassen on 03/12/2021.
//

import SwiftUI

@main
struct Bitakhon_iOSApp: App {
    @Resolve var initialCoordinator: InitialViewCoordinator

    var body: some Scene {
        WindowGroup {
			initialCoordinator.initialView()
        }
    }
}
