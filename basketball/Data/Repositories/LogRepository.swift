//
//  LogRepository.swift
//  basketball
//
//  Created by Michael Vivar on 28/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import Foundation

class LogRepository {
    
    static let shared = LogRepository()
    
    func read(for card: Card, completion: @escaping(_ data: [Log]) -> Void) {
        DataManager.load(card.id, type: [Log].self, folder: "logs", completion: { data in
            let logs = (data ?? [Log]()).sorted(by: { a, b in a.date.compare(b.date) == .orderedDescending })
            completion(logs)
        })
    }
    
    func create(_ log: Log, for card: Card) {
        read(for: card, completion: { data in
            var logs = data
            logs.append(log)
            DataManager.save(logs, name: card.id, folder: "logs", completion: {})
        })
    }
}
