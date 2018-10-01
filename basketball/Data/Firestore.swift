//
//  Firestore.swift
//  basketball
//
//  Created by Michael Vivar on 28/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import Foundation
import Firestore

class Store {
    
    private init() {}
    
    static var firestore: CollectionReference = {
        return Firestore.firestore().collection("games")
    }()
    
    static func save(_ card: Card) {
        
        let values = [
            "game": card.game,
            "date": card.date,
            "time": card.time,
            "bet": card.bet,
            "status": card.status,
            "progress": card.progress,
            "prizes": [
                "first": card.prizes.first,
                "second": card.prizes.second,
                "third": card.prizes.third,
                "fourth": card.prizes.fourth,
                "reverse": card.prizes.reverse
            ]
            ] as [String: Any]
        
        firestore.document(card.id).setData(values)
    }
    
    static func delete(_ card: Card) {
        //firestore.document(card.id).updateData([ "deleted": true ])
        firestore.document(card.id).delete()
    }
    
    static func save(slot: Slot, for card: Card) {
        
        let values = [
            "number": slot.number,
            "name": slot.name,
            "paid": slot.paid,
            "user": slot.user
            ] as [String: Any]
        
        firestore.document(card.id).collection("slots").document(slot.number).setData(values)
    }
    
    static func delete(slot: Slot, for card: Card) {
        firestore.document(card.id).collection("slots").document(slot.number).delete()
    }
}
