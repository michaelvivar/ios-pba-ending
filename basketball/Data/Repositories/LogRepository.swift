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
    
    private init() {}
    
    func read(for card: Card) -> [Log] {
        if let logs = _logs(card) {
            return logs
        }
        else {
            return [Log]()
        }
    }
    
    func create(log: Log, for card: Card) {
        var logs = read(for: card)
        logs.append(log)
        _save(logs: logs, for: card)
    }
    
    private func _logs(_ card: Card) -> [Log]? {
        if let file = DataManager.load(card.id + "-logs", with: Logs.self) {
            return file.data.sorted(by: { a, b in a.date.compare(b.date) == .orderedDescending })
        }
        return nil
    }
    
    private func _save(logs: [Log], for card: Card) {
        DataManager.save(Logs(data: logs), with: card.id + "-logs", completion: { file in
            
        })
    }
}

