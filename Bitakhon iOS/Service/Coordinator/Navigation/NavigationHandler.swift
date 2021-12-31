//
// Created by Mickael Belhassen on 31/12/2021.
//

import SwiftUI

struct NavigationHandler: ViewModifier {

    @Binding var navigationDirection: NavigationDirection?
    @State private var destination: NavigationDestination?
    @State private var sheetActive = false
    @State private var fullScreenCoverActive = false
    @State private var linkActive = false
    @Environment(\.presentationMode) var presentation // Todo deprecated iOS 15
    @Environment(\.dismiss) var dismiss
    var onDismiss: ((NavigationDestination) -> ())?


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
    private func buildDestination(_ destination: NavigationDestination?) -> some View {
        if let destination = destination {
            destination.view
        } else {
            EmptyView()
        }
    }

}


// MARK: - Navigation Handler

extension View {

    func handleNavigation(_ navigationDirection: Binding<NavigationDirection?>, onDismiss: ((NavigationDestination) -> ())? = nil) -> some View {
        modifier(NavigationHandler(navigationDirection: navigationDirection, onDismiss: onDismiss))
    }

}