//
// Created by Mickael Belhassen on 09/01/2022.
//

import Foundation

struct CreateOrUpdateEmergencyReq: Codable {
    let status: Emergency.Status
    let location: BTCLLocationCoordinate2D
}
