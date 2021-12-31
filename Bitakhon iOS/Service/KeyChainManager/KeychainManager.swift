//
// Created by Mickael Belhassen on 31/12/2021.
//

import Foundation

class KeychainManager {
    @KeychainStorage(key: "BTKAccessToken") static var userAccessToken: String?
}
