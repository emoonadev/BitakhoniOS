//
//  DoneAlert.swift.swift
//  Bitakhon iOS
//
//  Created by Mickael Belhassen on 12/12/2021.
//

import SwiftUI

struct DoneAlert<Item: Alertable>: ViewModifier {
	let item: Binding<Item?>

	func body(content: Content) -> some View {
		content.alert(item: item) { item in
			Alert(title: Text(item.title), message: Text(item.description), dismissButton: .default(Text("Done")))
		}
	}
}

extension View {
	func doneAlert<Item>(item: Binding<Item?>) -> some View where Item: Alertable {
		modifier(DoneAlert(item: item))
	}
}
