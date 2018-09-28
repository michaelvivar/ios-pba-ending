//
//  Slot+Ext.swift
//  basketball
//
//  Created by Michael Vivar on 27/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import Foundation

extension Slot {
    
    func save(in card: Card, name: String) {
        let slot = Slot(number: self.number, name: name, paid: false, user: "admin");
        SlotRepository.shared.create(slot: slot, for: card)
        Log(action: "Create", date: Date(), data: slot).save(in: card)
        card.update(progress: SlotRepository.shared.read(for: card).count)
    }
    
    func delete(in card: Card) {
        if (self.paid == false) {
            SlotRepository.shared.delete(slot: self, for: card)
            Log(action: "Delete", date: Date(), data: self).save(in: card)
            card.update(progress: SlotRepository.shared.read(for: card).count)
        }
    }
    
    func paid(in card: Card) {
        if (self.paid == false) {
            let slot = clone(with: true)
            SlotRepository.shared.update(slot: slot, for: card)
            Log(action: "Paid", date: Date(), data: slot).save(in: card)
            card.update(progress: SlotRepository.shared.read(for: card).count)
        }
    }
    
    func unpaid(in card: Card) {
        if (self.paid == true) {
            let slot = clone(with: false)
            SlotRepository.shared.update(slot: slot, for: card)
            Log(action: "Unpaid", date: Date(), data: slot).save(in: card)
            card.update(progress: SlotRepository.shared.read(for: card).count)
        }
    }
    
    func update(in card: Card, name: String) {
        if (self.name != name) {
            let slot = clone(with: name)
            SlotRepository.shared.update(slot: slot, for: card)
            Log(action: "Update", date: Date(), data: clone(with: self.name + " > " + name)).save(in: card)
            card.update(progress: SlotRepository.shared.read(for: card).count)
        }
    }
    
    func clone(with name: String) -> Slot {
        return Slot(number: self.number, name: name, paid: self.paid, user: self.user)
    }
    
    func clone(with paid: Bool) -> Slot {
        return Slot(number: self.number, name: self.name, paid: paid, user: self.user)
    }
}
