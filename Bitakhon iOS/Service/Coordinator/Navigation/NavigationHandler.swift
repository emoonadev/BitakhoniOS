//
// Created by Mickael Belhassen on 31/12/2021.
//

import SwiftUI
import Combine

protocol NavigationCoordinator {
    associatedtype Destination: RouteCoordinator
    var direction: PassthroughSubject<NavigationDirection<Destination>, Never> { get }
}

extension NavigationCoordinator {
    func callAsFunction() -> PassthroughSubject<NavigationDirection<Destination>, Never> { direction }
}

struct NavigationHandler<Destination: RouteCoordinator>: ViewModifier {

    @Binding var navigationDirection: NavigationDirection<Destination>?
    @State private var destination: Destination?
    @State private var sheetActive = false
    @State private var fullScreenCoverActive = false
    @State private var linkActive = false
    @Environment(\.presentationMode) var presentation // Todo deprecated iOS 15
    @Environment(\.dismiss) var dismiss
    var onDismiss: ((Destination) -> ())?


    func body(content: Content) -> some View {
        content
                .background(
                        EmptyView()
                                .sheet(isPresented: $sheetActive, onDismiss: {
                                    if let destination = destination {
                                        onDismiss?(destination)
                                    }
                                }) {
                                    buildDestination(destination)
                                }
                ).background(
                        EmptyView()
                                .fullScreenCover(isPresented: $fullScreenCoverActive, onDismiss: {
                                    if let destination = destination {
                                        onDismiss?(destination)
                                    }
                                }) {
                                    buildDestination(destination)
                                }
                )
                .background(
                        NavigationLink(destination: buildDestination(destination), isActive: $linkActive) {
                            EmptyView()
                        }
                ).onChange(of: navigationDirection) { direction in
                    switch direction {
                        case .forward(let destination, let style):
                            self.destination = destination

                            switch style {
                                case .present:
                                    sheetActive = true
                                case .fullScreenCover:
                                    fullScreenCoverActive = true
                                case .push:
                                    linkActive = true
                            }
                        case .back:
                            if #available(iOS 15, *) {
                                dismiss()
                            } else {
                                presentation.wrappedValue.dismiss()
                            }
                        case .none:
                            break
                    }
                    navigationDirection = nil
                }
    }

    @ViewBuilder
    private func buildDestination(_ destination: Destination?) -> some View {
        if let destination = destination {
            destination.view
        } else {
            EmptyView()
        }
    }

}


// MARK: - Navigation Handler

extension View {

    func handleNavigation<Destination: RouteCoordinator>(_ navigationDirection: Binding<NavigationDirection<Destination>?>, onDismiss: ((Destination) -> ())? = nil) -> some View {
        modifier(NavigationHandler(navigationDirection: navigationDirection, onDismiss: onDismiss))
    }

}
