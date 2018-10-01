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
    
    func read(for card: Card, completion: @escaping(_ slots: [Slot]) -> Void) {
        _slots(for: card, completion)
    }
    
    func create(_ slot: Slot, for card: Card, completion: @escaping(_ slots: [Slot]) -> Void) {
        _slots(for: card, { [unowned self] data in
            var slots = data
            slots.append(slot)
            self._save(slots, for: card, completion: {
                completion(slots)
                Store.save(slot: slot, for: card)
            })
        })
    }
    
    func update(_ slot: Slot, for card: Card, completion: @escaping() -> Void) {
        _slots(for: card, { [unowned self] data in
            if let index = data.firstIndex(where: { $0.number == slot.number }) {
                var slots = data
                slots[index] = slot
                self._save(slots, for: card, completion: {
                    completion()
                    Store.save(slot: slot, for: card)
                })
            }
        })
    }
    
    func delete(_ slot: Slot, for card: Card, completion: @escaping(_ slots: [Slot]) -> Void) {
        _slots(for: card, { [unowned self] data in
            if let index = data.firstIndex(where: { $0.number == slot.number }) {
                var slots = data
                slots.remove(at: index)
                self._save(slots, for: card, completion: {
                    completion(slots)
                    Store.delete(slot: slot, for: card)
                })
            }
        })
    }
}

extension SlotRepository {
    
    private func _slots(for card: Card, _ completion: @escaping(_ cards: [Slot]) -> Void) {
        DataManager.load(card.id, type: [Slot].self, folder: "slots", completion: { data in
            completion(data ?? [Slot]())
        })
    }
    
    private func _save(_ slots: [Slot], for card: Card, completion: @escaping() -> Void) {
        DataManager.save(slots, name: card.id, folder: "slots", completion: completion)
    }
}
