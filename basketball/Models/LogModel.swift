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
}
