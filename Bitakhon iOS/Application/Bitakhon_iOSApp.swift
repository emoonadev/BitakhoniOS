//
//  Bitakhon_iOSApp.swift
//  Bitakhon iOS
//
//  Created by Mickael Belhassen on 03/12/2021.
//

import SwiftUI

@main
struct Bitakhon_iOSApp: App {

    @Resolve var backgroundTasks: BackgroundTasksService
    @Environment(\.scenePhase) var scenePhase
    @Resolve var initialCoordinator: InitialViewCoordinator


    var body: some Scene {
        WindowGroup {
            initialCoordinator.initialView()
                    .onOpenURL { url in }
        }.onChange(of: scenePhase) { newScenePhase in
            switch scenePhase {
                case .background:
                    break
                case .inactive:
                    backgroundTasks.runRequiredTasks()
                case .active:
                    break
                @unknown default:
                    break
            }
        }
    }
}
