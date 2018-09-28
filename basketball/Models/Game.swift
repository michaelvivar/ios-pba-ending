//
//  Game.swift
//  basketball
//
//  Created by Michael Vivar on 29/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import Foundation

struct GameModel {
    let date: Date
    let time: String
    let status: Bool
}

struct GameModel1 {
    let date: Date
    let time: String
    let status: Bool
}

extension GameModel1: Game1 {
    func save() {
        
    }
}

struct GameModel2 : Game  {
    let date: Date
    let time: String
    let status: Bool
}

extension GameModel2 {
    func update(date: Date, time: String) {
        
    }
    
    func toggle() {
        
    }
    
}


class GameFactory {
    
    class func create(date: Date, time: String, status: Bool) -> Game1 {
        return GameModel1(date: date, time: time, status: status)
    }
    
    class func create(_ game: GameModel) -> Game {
        return GameModel2(date: game.date, time: game.time, status: game.status)
    }
}

protocol Game1 {
    func save()
}

protocol Game {
    func update(date: Date, time: String)
    func toggle()
}
