//
//  Store.swift
//  basketball
//
//  Created by Michael Vivar on 24/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import Foundation

class DataManager {
    
    static var delegate: DataManagerDelegate!
    
    static fileprivate func getDocumentURL() -> URL {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
        }
        else {
            fatalError("Unable to access file directory!")
        }
    }
    
    static func save<T:Encodable>(_ object: T, with id: String) {
        let url = getDocumentURL().appendingPathComponent(id, isDirectory: false)
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(object)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
            delegate.reload(with: object)
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
    static func load<T:Decodable>(_ id: String, with type: T.Type) -> T {
        let url = getDocumentURL().appendingPathComponent(id, isDirectory: false)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            fatalError("file not found at path \(url.path)")
        }
        
        if let data = FileManager.default.contents(atPath: url.path) {
            do {
                let model = try JSONDecoder().decode(type, from: data)
                return model
            }
            catch {
                fatalError(error.localizedDescription)
            }
        }
        else {
            fatalError("Data unavailable at path \(url.path)")
        }
    }
    
    static func data(_ id: String) -> Data? {
        let url = getDocumentURL().appendingPathComponent(id, isDirectory: false)
        if !FileManager.default.fileExists(atPath: url.path) {
            fatalError("file not found at path \(url.path)")
        }
        
        if let data = FileManager.default.contents(atPath: url.path) {
            return data
        }
        else {
            fatalError("Data unavailable at path \(url.path)")
        }
    }
    
    static func all<T:Decodable>(_ type:T.Type) -> [T] {
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: getDocumentURL().path)
            
            var data = [T]()
            
            for file in files {
                if (file != "logs" && file != "slots" && file != ".DS_Store") {
                    data.append(load(file, with: type))
                }
            }
            return data
        }
        catch {
            fatalError("Could not load any files")
        }
    }
    
    static func delete(_ id: String) {
        let url = getDocumentURL().appendingPathComponent(id, isDirectory: false)
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
            }
            catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}

protocol DataManagerDelegate {
    func reload(with data: Any)
}


/*
class Store {
    
    static let cards = Store()
    private var _data: Dictionary<String, Card> = Dictionary<String, Card>()
    
    private init() {
        
    }
    
    func data() -> Dictionary<String, Card> {
        return self._data
    }
    
    func set(_ card: Card) {
        var id = card.id
        if let item = _data.first(where: { $0.key == card.id }) {
            if let slots = item.value.slots {
                if (card.slots == nil) {
                    _data.updateValue(card.clone(slots: slots, status: item.value.status, progress: item.value.progress), forKey: item.key)
                    return
                }
            }
        }
        else {
            id = generateId(card)
        }
        _data.updateValue(card, forKey: id)
    }
    
    func delete(_ card: Card) {
        if (card.status == false) {
            if let item = _data.first(where: { $0.key == card.id }) {
                _data.removeValue(forKey: item.key)
            }
        }
    }
    
    func toggleStatus(card: Card) {
        let status = !card.status
        if let item = _data.first(where: { $0.key == card.id }) {
            set(card.clone(slots: item.value.slots, status: status, progress: item.value.progress))
        }
    }
    
    func delete(card: Card, slot: Slot) {
        if (slot.paid == false) {
            if let item = _data.first(where: { $0.key == card.id }) {
                if var slots = item.value.slots {
                    slots.removeValue(forKey: slot.number)
                    set(card.clone(slots: slots, status: item.value.status, progress: slots.count))
                }
            }
        }
    }
    
    private func generateId(_ card: Card) -> String {
        return "dummy-id"
    }
}

extension Store {
    
    private func set(card: Card, slot: Slot) {
        if let item = _data.first(where: { $0.key == card.id }) {
            if var slots = item.value.slots {
                slots.updateValue(slot, forKey: slot.number)
                set(card.clone(slots: slots, status: item.value.status, progress: slots.count))
            }
            else {
                var slots = Dictionary<String, Slot>()
                slots.updateValue(slot, forKey: slot.number)
                set(card.clone(slots: slots, status: item.value.status, progress: 1))
            }
        }
    }
    
    func paidSlot(card: Card, slot: Slot) {
        set(card: card, slot: slot.clone(name: nil, paid: true))
    }
    
    func unpaidSlot(card: Card, slot: Slot) {
        set(card: card, slot: slot.clone(name: nil, paid: false))
    }
    
    func addSlot(card: Card, number: String, name: String) {
        let slot = Slot(number: number, name: name, paid: false, section: section(number), user: "admin")
        set(card: card, slot: slot)
    }
    
    func updateSlot(card: Card, slot: Slot, name: String) {
        set(card: card, slot: slot.clone(name: name, paid: nil))
    }
    
    private func section(_ number: String) -> Int {
        return 1
    }
}
*/
