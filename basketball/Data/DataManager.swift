//
//  DataManager.swift
//  basketball
//
//  Created by Michael Vivar on 28/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import Foundation

class DataManager {
    
    static fileprivate func getDocumentURL() -> URL {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
        }
        else {
            fatalError("Unable to access file directory!")
        }
    }
    
    static func save<T:Encodable>(_ object: T, with id: String, completion: @escaping(_ data: T) -> ()) {
        let url = getDocumentURL().appendingPathComponent(id, isDirectory: false)
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(object)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
            DispatchQueue.main.async {
                completion(object)
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    static func load<T:Decodable>(_ id: String, with type: T.Type) -> T? {
        let url = getDocumentURL().appendingPathComponent(id, isDirectory: false)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            print("file not found at path \(url.path)")
        }
        
        if let data = FileManager.default.contents(atPath: url.path) {
            do {
                let model = try JSONDecoder().decode(type, from: data)
                return model
            }
            catch {
                print(error.localizedDescription)
            }
        }
        else {
            print("Data unavailable at path \(url.path)")
        }
        return nil
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
                if let item = load(file, with: type) {
                    data.append(item)
                }
            }
            return data
        }
        catch {
            print("Could not load any files")
        }
        return [T]()
    }
    
    static func delete(_ id: String) {
        let url = getDocumentURL().appendingPathComponent(id, isDirectory: false)
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}
