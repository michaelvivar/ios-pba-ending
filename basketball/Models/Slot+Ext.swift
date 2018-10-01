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
        let slot = Slot(number: self.number, name: name, paid: false, user: "admin")
        SlotRepository.shared.create(slot, for: card, completion: { slots in
            card.update(progress: slots.count)
            Log(action: "Create", data: slot).save(in: card)
        })
    }
    
    func delete(in card: Card) {
        if (self.paid == false) {
            SlotRepository.shared.delete(self, for: card, completion: { slots in
                card.update(progress: slots.count)
                Log(action: "Delete", data: self).save(in: card)
            })
        }
    }
    
    func paid(for card: Card) {
        if (self.paid == false) {
            let slot = clone(with: true)
            SlotRepository.shared.update(slot, for: card, completion: {
                Log(action: "Paid", data: slot).save(in: card)
            })
        }
    }
    
    func unpaid(for card: Card) {
        if (self.paid == true) {
            let slot = clone(with: false)
            SlotRepository.shared.update(slot, for: card, completion: {
                Log(action: "Unpaid", data: slot).save(in: card)
            })
        }
    }
    
    func update(for card: Card, name: String) {
        if (self.name != name) {
            let slot = clone(with: name)
            SlotRepository.shared.update(slot, for: card, completion: {
                Log(action: "Update", data: self.clone(with: self.name + " > " + name)).save(in: card)
            })
        }
    }
    
    func clone(with name: String) -> Slot {
        return Slot(number: self.number, name: name, paid: self.paid, user: "admin")
    }
    
    func clone(with paid: Bool) -> Slot {
        return Slot(number: self.number, name: self.name, paid: paid, user: "admin")
    }
}
