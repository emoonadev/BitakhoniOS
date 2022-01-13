//
// Created by Mickael Belhassen on 12/01/2022.
//

import Foundation

protocol BackgroundTasksService {
    func runRequiredTasks()
}

class BackgroundTasks: BackgroundTasksService {
    let apiClient: APIClientService


    init(apiClient: APIClientService) {
        self.apiClient = apiClient
    }
}


// MARK: - Required tasks

extension BackgroundTasks {

    func runRequiredTasks() {
    }

}
