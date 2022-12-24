//
// Created by Mickael Belhassen on 31/12/2021.
//

import SwiftUI

protocol RouteCoordinator {
    associatedtype DestinationView: View
    var view: DestinationView { get }
}

enum NavigationDirection<Destination: RouteCoordinator>: Equatable {
    
    static func ==(lhs: NavigationDirection, rhs: NavigationDirection) -> Bool {
        false
    }
    
    case back
    case forward(destination: Destination, style: NavigationStyle)
}
