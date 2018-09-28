//
//  SlotRepository.swift
//  basketball
//
//  Created by Michael Vivar on 28/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import Foundation

class SlotRepository {
    
    static let shared = SlotRepository()
    
    private init() {}
    
    func read(for card: Card) -> [Slot] {
        if let slots = _slots(card) {
            return slots
        }
        else {
            return [Slot]()
        }
    }
    
    func create(slot: Slot, for card: Card) {
        var slots = read(for: card)
        slots.append(slot)
        _save(slots: slots, for: card)
        Cloud.save(slot: slot, for: card)
    }
    
    func update(slot: Slot, for card: Card) {
        var slots = read(for: card)
        if let index = slots.firstIndex(where: { $0.number == slot.number }) {
            slots[index] = slot
            _save(slots: slots, for: card)
            Cloud.save(slot: slot, for: card)
        }
    }
    
    func delete(slot: Slot, for card: Card) {
        var slots = read(for: card)
        if let index = slots.firstIndex(where: { $0.number == slot.number }) {
            slots.remove(at: index)
            _save(slots: slots, for: card)
            Cloud.delete(slot: slot, for: card)
        }
    }
    
    private func _slots(_ card: Card) -> [Slot]? {
        if let file = DataManager.load(card.id + "-slots", with: Slots.self) {
            return file.data
        }
        return nil
    }
    
    private func _save(slots: [Slot], for card: Card) {
        DataManager.save(Slots(data: slots), with: card.id + "-slots", completion: { file in
            
        })
    }
}
