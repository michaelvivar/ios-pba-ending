//
//  CardModel.swift
//  basketball
//
//  Created by Michael Vivar on 24/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import Foundation

struct Card: Codable {
    let id: String
    let game: String
    let date: Date
    let time: String
    let bet: Int
    let status: Bool
    let progress: Int
    let prizes: Prizes
    let slots: [Slot]?
    let logs: [Log]?
}

struct Cards: Codable {
    let data: [Card]
}
