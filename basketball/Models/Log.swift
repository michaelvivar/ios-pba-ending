//
//  LogModel.swift
//  basketball
//
//  Created by Michael Vivar on 25/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import Foundation

struct Log: Codable {
    let action: String
    let date: Date
    let data: Slot
    
    init(action: String, data: Slot) {
        self.action = action
        self.data = data
        self.date = Date()
    }
    
    init(action: String, date: Date, data: Slot) {
        self.action = action
        self.date = date
        self.data = data
    }
}
