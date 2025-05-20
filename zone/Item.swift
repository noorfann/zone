//
//  Item.swift
//  zone
//
//  Created by Zulfikar Noorfan on 20/05/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
