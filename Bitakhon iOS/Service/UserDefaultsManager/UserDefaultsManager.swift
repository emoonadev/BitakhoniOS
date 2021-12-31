//
// Created by Mickael Belhassen on 31/12/2021.
//

import Foundation

final class UserDefaultsManager {
    @Storage(key: "BTLoggedUser", defaultValue: nil)
    static var loggedUser: User?
}
