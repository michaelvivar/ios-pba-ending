//
//  DataManager.swift
//  basketball
//
//  Created by Michael Vivar on 28/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import Foundation

class DataManager {
    
    static fileprivate func createDirectory(_ url: URL) {
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
        }
        catch {
            fatalError("Failed to create file directory!")
        }
    }
    
    static fileprivate func document(_ folder: String = "") -> URL {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            if folder.isEmpty {
                return url
            }
            else {
                let dir = url.appendingPathComponent(folder, isDirectory: true)
                if (!(FileManager.default.fileExists(atPath: dir.path))) {
                    createDirectory(dir)
                }
                return dir
            }
        }
        else {
            fatalError("Unable to access file directory!")
        }
    }
    
    static func save<T: Encodable>(_ data: T, name: String, folder: String?, completion: (() -> Void)?) {
        var url: URL = {
            if let folder = folder {
                return document(folder)
            }
            else {
                return document()
            }
        }()
        
        url.appendPathComponent(name, isDirectory: false)
        
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(data)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            DispatchQueue.global(qos: .userInteractive).async {
                FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
                DispatchQueue.main.async {
                    if let then = completion {
                        then()
                    }
                }
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    static func load<T: Decodable>(_ name: String, type: T.Type, folder: String?, completion: @escaping(_ data: T?) -> Void) {
        var url: URL = {
            if let folder = folder {
                return document(folder)
            }
            else {
                return document()
            }
        }()
        
        url.appendPathComponent(name, isDirectory: false)
        
        if let data = FileManager.default.contents(atPath: url.path) {
            do {
                let model = try JSONDecoder().decode(type, from: data)
                completion(model)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        else {
            completion(nil)
            //print("Data unavailable at path \(url.path)")
        }
    }
    
    static func delete(_ name: String, folder: String?, completion: @escaping() -> Void) {
        var url: URL = {
            if let folder = folder {
                return document(folder)
            }
            else {
                return document()
            }
        }()
        
        url.appendPathComponent(name, isDirectory: false)
        
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
                DispatchQueue.main.async {
                    completion()
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}
