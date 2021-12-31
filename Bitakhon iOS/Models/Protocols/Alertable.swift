//
//  Alertable.swift
//  Bitakhon iOS
//
//  Created by Mickael Belhassen on 06/12/2021.
//

import Foundation

protocol Alertable: Identifiable {
	var id: Int { get }
	var title: String { get }
	var description: String { get }
}

extension Alertable {
	var id: Int { Int.random(in: 0 ... 500) }
}
