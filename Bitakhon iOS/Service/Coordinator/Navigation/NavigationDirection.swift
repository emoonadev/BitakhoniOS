//
// Created by Mickael Belhassen on 31/12/2021.
//

import Foundation

enum NavigationDirection: Equatable {

    static func ==(lhs: NavigationDirection, rhs: NavigationDirection) -> Bool {
        false
    }

    case back
    case forward(destination: NavigationDestination, style: NavigationStyle)
}
