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

struct CardModel {
    let id: String
    let game: String
    let date: Date
    let time: String
    let bet: Int
    let prizes: Prizes
    
    init(game: String, date: Date, time: String, bet: Int, prizes: Prizes) {
        self.id = ""
        self.game = game
        self.date = date
        self.time = time
        self.bet = bet
        self.prizes = prizes
    }
}
