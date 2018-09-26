//
//  SlotModel.swift
//  basketball
//
//  Created by Michael Vivar on 25/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import Foundation

struct Slot: Codable {
    let number: String
    let name: String
    let paid: Bool
    let user: String
}

extension Slot {
    
    func save(in card: Card, name: String) -> Card {
        var slots = card.slots ?? [Slot]()
        var logs = card.logs ?? [Log]()
        let slot = Slot(number: self.number, name: name, paid: false, user: "admin");
        slots.append(slot)
        logs.append(Log(action: "Create", date: Date(), data: slot))
        return Card(id: card.id, game: card.game, date: card.date, time: card.time, bet: card.bet, status: card.status, progress: slots.count, prizes: card.prizes, slots: slots, logs: logs).update()
    }
    
    func delete(in card: Card) -> Card {
        if var slots = card.slots, let index = slots.firstIndex(where: { $0.number == self.number }) {
            slots.remove(at: index)
            var logs = card.logs
            logs?.append(Log(action: "Delete", date: Date(), data: self))
            return Card(id: card.id, game: card.game, date: card.date, time: card.time, bet: card.bet, status: card.status, progress: slots.count, prizes: card.prizes, slots: slots, logs: logs).update()
        }
        return card
    }
    
    func paid(in card: Card) -> Card {
        if var slots = card.slots, let index = slots.firstIndex(where: { $0.number == self.number }) {
            let slot = Slot(number: self.number, name: self.name, paid: true, user: self.user)
            slots[index] = slot
            var logs = card.logs
            logs?.append(Log(action: "Paid", date: Date(), data: slot))
            return Card(id: card.id, game: card.game, date: card.date, time: card.time, bet: card.bet, status: card.status, progress: slots.count, prizes: card.prizes, slots: slots, logs: logs).update()
        }
        return card
    }
    
    func unpaid(in card: Card) -> Card {
        if var slots = card.slots, let index = slots.firstIndex(where: { $0.number == self.number }) {
            let slot = Slot(number: self.number, name: self.name, paid: false, user: self.user)
            slots[index] = slot
            var logs = card.logs
            logs?.append(Log(action: "Unpaid", date: Date(), data: slot))
            return Card(id: card.id, game: card.game, date: card.date, time: card.time, bet: card.bet, status: card.status, progress: slots.count, prizes: card.prizes, slots: slots, logs: logs).update()
        }
        return card
    }
    
    func update(in card: Card, name: String) -> Card{
        if var slots = card.slots, let index = slots.firstIndex(where: { $0.number == self.number }) {
            slots[index] = Slot(number: self.number, name: name, paid: self.paid, user: self.user)
            var logs = card.logs
            logs?.append(Log(action: "Update", date: Date(), data: Slot(number: self.number, name: self.name + " > " + name, paid: self.paid, user: self.user)))
            return Card(id: card.id, game: card.game, date: card.date, time: card.time, bet: card.bet, status: card.status, progress: slots.count, prizes: card.prizes, slots: slots, logs: logs).update()
        }
        return card
    }
}
