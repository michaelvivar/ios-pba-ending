//
//  CardRepository.swift
//  basketball
//
//  Created by Michael Vivar on 28/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import Foundation

class CardRepository {
    
    static let shared = CardRepository()
    
    var delegate: DataCardDelegate!
    
    private init() {}
    
    func read(_ completion: @escaping(_ cards: [Card]) -> Void) {
        _cards(completion)
    }
    
    func create(_ card: Card, completion: @escaping() -> Void) {
        _cards({ [unowned self] data in
            var cards = data
            cards.append(card)
            self._save(cards, completion: completion)
            Store.save(card)
        })
    }
    
    func update(_ card: Card, completion: @escaping() -> Void) {
        _cards({ [unowned self] data in
            if let index = data.firstIndex(where: { $0.id == card.id }) {
                var cards = data
                cards[index] = card
                self._save(cards, completion: completion)
                Store.save(card)
            }
        })
    }
    
    func delete(_ card: Card, completion: @escaping() -> Void) {
        _cards({ [unowned self] data in
            var cards = data
            if let index = cards.firstIndex(where: { $0.id == card.id }) {
                cards.remove(at: index)
                self._save(cards, completion: completion)
                DataManager.delete(card.id, folder: "slots", completion: {})
                DataManager.delete(card.id, folder: "logs", completion: {})
                Store.delete(card)
            }
        })
    }
}

extension CardRepository {
    
    private func sort(_ cards: [Card]) -> [Card] {
        var on = cards.filter({ $0.status == true }).sorted(by: { a, b in a.date.compare(b.date) == .orderedAscending })
        let off = cards.filter({ $0.status == false }).sorted(by: { a, b in a.date.compare(b.date) == .orderedDescending })
        on.append(contentsOf: off)
        return on
    }
    
    private func _cards(_ completion: @escaping(_ cards: [Card]) -> Void) {
        DataManager.load("cards", type: [Card].self, folder: nil, completion: { [unowned self] data in
            let cards = (data ?? [Card]()).sorted(by: { a, b in a.date.compare(b.date) == .orderedDescending })
            completion(self.sort(cards))
        })
    }
    
    private func _save(_ cards: [Card], completion: @escaping() -> Void) {
        DataManager.save(cards, name: "cards", folder: nil, completion: { [unowned self] in
            completion()
            self.delegate.reload(with: self.sort(cards))
        })
    }
}

protocol DataCardDelegate {
    func reload(with cards: [Card])
}
