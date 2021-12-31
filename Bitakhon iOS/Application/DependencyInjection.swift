//
//  DependencyInjection.swift
//  Bitakhon iOS
//
//  Created by Mickael Belhassen on 03/12/2021.
//

import Foundation

extension DependencyFactory {
	override func registerDependencies() {
		registerServices()
		registerRepositories()
		registerViewModels()
	}

	private func registerServices() {
		register(APIClientService.self, instanceType: .single) { r in r.autoResolve(APIClient.init) }
		register(InitialViewCoordinator.self, instanceType: .single) { r in r.autoResolve(InitialViewCoordinator.init) }
	}

	private func registerRepositories() {
		register(UserRepositoryService.self, instanceType: .single) { r in r.autoResolve(UserRepository.init) }
	}

	private func registerViewModels() {
		register { r in r.autoResolve(LoginViewModel.init) }
	}
}
