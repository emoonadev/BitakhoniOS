//
// Created by Mickael Belhassen on 03/01/2022.
//

import Foundation

struct Emergency: Codable {
    let id: UUID
    let status: Status
    let location: BTCLLocationCoordinate2D
    let updatedAt: Date
    let createdAt: Date
}


// MARK: - Models

extension Emergency {
    enum Status: Int, Codable {
        case opened, canceled, resolved
    }
}
