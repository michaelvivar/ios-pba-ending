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

struct Prizes: Codable {
    let first: Int
    let second: Int
    let third: Int
    let fourth: Int
    let reverse: Int
}

extension Card {
    
    func save() {
        let id = self.date.format("yyyyMMdd") + "-" + self.generateID()
        DataManager.save(Card(id: id, game: self.game, date: self.date, time: self.time, bet: self.bet, status: true, progress: 0, prizes: self.prizes, slots: nil, logs: nil), with: id)
    }
    
    func delete() {
        DataManager.delete(self.id)
    }
    
    func update() -> Card {
        DataManager.save(self, with: self.id)
        return self
    }
    
    func update(game: String, date: Date, time: String, bet: Int, prizes: Prizes) {
        let card = Card(id: self.id, game: game, date: date, time: time, bet: bet, status: self.status, progress: self.progress, prizes: prizes, slots: self.slots, logs: self.logs)
        DataManager.save(card, with: self.id)
    }
    
    func toggle() {
        let status = !self.status
        let card = Card(id: self.id, game: self.game, date: self.date, time: self.time, bet: self.bet, status: status, progress: self.progress, prizes: self.prizes, slots: self.slots, logs: nil)
        DataManager.save(card, with: self.id)
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


/*
extension Card {
    
    func teams() -> Teams {
        let arr = self.game.components(separatedBy: " vs ")
        if let visitor: String = arr.first, let home: String = arr.last {
            return Teams(home: home, visitor: visitor)
        }
        else {
            return Teams(home: "", visitor: "")
        }
    }
    
    func map() -> [String: Any] {
        return [:]
    }
    
    func clone(slots: Dictionary<String, Slot>?, status: Bool?, progress: Int?) -> Card {
        return Card(
            id: self.id,
            game: self.game,
            date: self.date,
            time: self.time,
            bet: self.bet,
            status: (status ?? self.status),
            progress: (progress ?? self.progress),
            prizes: self.prizes,
            slots: (slots ?? self.slots)
        )
    }
}

struct Teams {
    let home: String
    let visitor: String
}
*/
