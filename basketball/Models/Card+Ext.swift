//
//  Card+Ext.swift
//  basketball
//
//  Created by Michael Vivar on 27/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import Foundation

extension Card {
    
    func delete(_ then: @escaping() -> Void) {
        if (self.status == false) {
            CardRepository.shared.delete(self, completion: then)
        }
    }
    
    func update(game: String, date: Date, time: String, bet: Int, prizes: Prizes) {
        let card = Card(id: self.id, game: game, date: date, time: time, bet: bet, status: self.status, progress: progress, prizes: prizes, slots: nil, logs: nil)
        CardRepository.shared.update(card, completion: nil)
    }
    
    func update(progress: Int) {
        CardRepository.shared.update(clone(with: progress), completion: nil)
    }
    
    func toggle(_ then: @escaping(_ card: Card) -> Void) {
        let card = clone(with: !self.status)
        CardRepository.shared.update(card, completion: {
            then(card)
        })
    }
    
    func clone(with progress: Int) -> Card {
        return Card(id: id, game: self.game, date: self.date, time: self.time, bet: self.bet, status: self.status, progress: progress, prizes: self.prizes, slots: nil, logs: nil)
    }
    
    private func clone(with status: Bool) -> Card {
        return Card(id: id, game: self.game, date: self.date, time: self.time, bet: self.bet, status: status, progress: self.progress, prizes: self.prizes, slots: nil, logs: nil)
    }
    
    func clone(with slots: [Slot]) -> Card {
        return Card(id: id, game: self.game, date: self.date, time: self.time, bet: self.bet, status: self.status, progress: self.progress, prizes: self.prizes, slots: slots, logs: nil)
    }
    
    func clone(with logs: [Log]) -> Card {
        return Card(id: id, game: self.game, date: self.date, time: self.time, bet: self.bet, status: self.status, progress: self.progress, prizes: self.prizes, slots: nil, logs: logs)
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
}

extension CardModel {
    
    func save(_ then: @escaping() -> Void) {
        let id = self.date.format("yyyyMMdd") + "-" + generateID()
        let card = Card(id: id, game: game, date: date, time: time, bet: bet, status: true, progress: 0, prizes: self.prizes, slots: nil, logs: nil)
        CardRepository.shared.create(card, completion: then)
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
