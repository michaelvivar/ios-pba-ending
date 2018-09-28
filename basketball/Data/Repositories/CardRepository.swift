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
    
    private init() {}
    
    func read() -> [Card] {
        if let cards = cards() {
            return cards
        }
        else {
            return [Card]()
        }
    }
    
    func create(card: Card) {
        var cards = read()
        cards.append(card)
        save(cards)
        Cloud.save(card)
    }
    
    func update(card: Card) {
        var cards = read()
        if let index = cards.firstIndex(where: { $0.id == card.id }) {
            cards[index] = card
            save(cards)
            Cloud.save(card)
        }
    }
    
    func delete(card: Card) {
        var cards = read()
        if let index = cards.firstIndex(where: { $0.id == card.id }) {
            cards.remove(at: index)
            save(cards)
            DataManager.delete(card.id + "-slots")
            DataManager.delete(card.id + "-logs")
            Cloud.delete(card)
        }
    }
    
    private func cards() -> [Card]? {
        if let file = DataManager.load("cards", with: Cards.self) {
            return file.data.sorted(by: { a, b in a.date.compare(b.date) == .orderedDescending })
        }
        return nil
    }
    
    private func save(_ cards: [Card]) {
        DataManager.save(Cards(data: cards), with: "cards", completion: { [unowned self] file in
            self.delegate.reload(with: file.data.sorted(by: { a, b in a.date.compare(b.date) == .orderedDescending }))
        })
    }
    
    var delegate: DataCardDelegate!
}

protocol DataCardDelegate {
    func reload(with data: [Card])
}
