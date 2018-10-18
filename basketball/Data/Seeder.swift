//
//  Seeder.swift
//  basketball
//
//  Created by Michael Vivar on 01/10/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import Foundation

class Seeder {
    
    func initialize(_ then: @escaping(_ cards: [Card]) -> Void) {
        Store.firestore.getDocuments(completion: {
            snapshot, error in
            if let error = error {
                print(error)
            }
            else {
                if let snapshot = snapshot {
                    let cards: [Card]? = snapshot.documents.compactMap({ doc in
                        let data = doc.data() as [String: Any]
                        guard let game = data["game"] as? String else { return nil }
                        guard let date = data["date"] as? Date else { return nil }
                        guard let time = data["time"] as? String else { return nil }
                        guard let bet = data["bet"] as? Int else { return nil }
                        guard let status = data["status"] as? Bool else { return nil }
                        guard let progress = data["progress"] as? Int else { return nil }
                        guard let prizes = data["prizes"] as? [String : Any] else { return nil }
                        guard let firstQtr = prizes["first"] as? Int else { return nil }
                        guard let secondQtr = prizes["second"] as? Int else { return nil }
                        guard let thirdQtr = prizes["third"] as? Int else { return nil }
                        guard let fourthQtr = prizes["fourth"] as? Int else { return nil }
                        guard let reverse = prizes["reverse"] as? Int else { return nil }
                        let deleted = (data["deleted"] as? Bool) ?? false
                        let id = deleted ? "" : doc.documentID
                        let card = Card(id: id, game: game, date: date, time: time,
                                        bet: bet, status: status, progress: progress,
                                        prizes: Prizes(firstQtr: firstQtr, secondQtr: secondQtr, thirdQtr: thirdQtr, fourthQtr: fourthQtr, reverse: reverse),
                                        slots: nil, logs: nil
                        )
                        return card
                    })
                    if let cards = cards {
                        let filtered = cards.filter({ $0.id != "" })
                        DataManager.save(filtered, name: "cards", folder: nil, completion: {
                            then(filtered)
                            filtered.forEach({ [unowned self] in
                                self.slots($0)
                                self.logs($0)
                            })
                        })
                    }
                }
            }
        })
    }
    
    private func slots(_ card: Card) {
        Store.firestore.document(card.id).collection("slots").getDocuments(completion: {
            snapshot, error in
            if let error = error {
                print(error)
            }
            else {
                if let snapshot = snapshot {
                    let slots: [Slot]? = snapshot.documents.compactMap({ doc in
                        let data = doc.data() as [String: Any]
                        guard let number = data["number"] as? String else { return nil }
                        guard let name = data["name"] as? String else { return nil }
                        guard let paid = data["paid"] as? Bool else { return nil }
                        guard let user = data["user"] as? String else { return nil }
                        let slot = Slot(number: number, name: name, paid: paid, user: user)
                        return slot
                    })
                    if let slots = slots {
                        DataManager.save(slots, name: card.id, folder: "slots", completion: {})
                    }
                }
            }
        })
    }
    
    private func logs(_ card: Card) {
        Store.firestore.document(card.id).collection("logs").getDocuments(completion: {
            snapshot, error in
            if let error = error {
                print(error)
            }
            else {
                if let snapshot = snapshot {
                    let logs: [Log]? = snapshot.documents.compactMap({ doc in
                        let data = doc.data() as [String: Any]
                        guard let action = data["action"] as? String else { return nil }
                        guard let date = data["date"] as? Date else { return nil }
                        guard let slot = data["data"] as? [String: Any] else { return nil }
                        guard let number = slot["number"] as? String else { return nil }
                        guard let name = slot["name"] as? String else { return nil }
                        guard let paid = slot["paid"] as? Bool else { return nil }
                        guard let user = slot["user"] as? String else { return nil }
                        let item = Slot(number: number, name: name, paid: paid, user: user)
                        let log = Log(action: action, date: date, data: item)
                        return log
                    })
                    if let logs = logs {
                        DataManager.save(logs, name: card.id, folder: "logs", completion: {})
                    }
                }
            }
        })
    }
}
