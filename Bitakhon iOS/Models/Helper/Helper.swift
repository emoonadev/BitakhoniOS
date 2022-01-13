//
// Created by Mickael Belhassen on 03/01/2022.
//

import Foundation

struct Helper: Codable {
    let id: UUID
    let location: BTCLLocationCoordinate2D
    let user: User
    let emergency: Emergency
    let updatedAt: Date
    let createdAt: Date
}
