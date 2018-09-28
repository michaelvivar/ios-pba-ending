//
//  Card+Ext.swift
//  basketball
//
//  Created by Michael Vivar on 27/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import Foundation

extension Card {
    
    func save() {
        let id = self.date.format("yyyyMMdd") + "-" + self.generateID()
        let card = Card(id: id, game: self.game, date: self.date, time: self.time, bet: self.bet, status: true, progress: 0, prizes: self.prizes, slots: nil, logs: nil)
        
        CardRepository.shared.create(card: card)
    }
    
    func delete() {
        if (self.status == false) {
            CardRepository.shared.delete(card: self)
        }
    }
    
    func update(progress: Int) {
        CardRepository.shared.update(card: clone(with: progress))
    }
    
    func update(game: String, date: Date, time: String, bet: Int, prizes: Prizes) {
        let card = Card(id: self.id, game: game, date: date, time: time, bet: bet, status: self.status, progress: self.progress, prizes: prizes, slots: nil, logs: nil)
        CardRepository.shared.update(card: card)
    }
    
    func toggle() -> Card {
        let card = clone(with: !self.status)
        CardRepository.shared.update(card: card)
        return card
    }
    
    func clone(with progress: Int) -> Card {
        let card = Card(id: id, game: self.game, date: self.date, time: self.time, bet: self.bet, status: self.status, progress: progress, prizes: self.prizes, slots: nil, logs: nil)
        return card
    }
    
    func clone(with status: Bool) -> Card {
        let card = Card(id: id, game: self.game, date: self.date, time: self.time, bet: self.bet, status: status, progress: self.progress, prizes: self.prizes, slots: nil, logs: nil)
        return card
    }
    
    func clone(with slots: [Slot]) -> Card {
        let card = Card(id: id, game: self.game, date: self.date, time: self.time, bet: self.bet, status: self.status, progress: self.progress, prizes: self.prizes, slots: slots, logs: nil)
        return card
    }
    
    func clone(with logs: [Log]) -> Card {
        let card = Card(id: id, game: self.game, date: self.date, time: self.time, bet: self.bet, status: self.status, progress: self.progress, prizes: self.prizes, slots: nil, logs: logs)
        return card
    }
    
    var teams: Dictionary<String, String> {
        get {
            var dictionary = Dictionary<String, String>()
            let arr = self.game.components(separatedBy: " vs ")
            if let visitor: String = arr.first, let home: String = arr.last {
                dictionary["visitor"] = visitor
                dictionary["home"] = home
            }
            return dictionary
        }
    }
    
    private func generateID() -> String {
        let letters : NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var len = 5 // length
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        repeat {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
            len = len - 1
        } while len > 0
        return randomString as String
    }
}
