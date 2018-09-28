//
//  Log+Ext.swift
//  basketball
//
//  Created by Michael Vivar on 27/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import Foundation

extension Log {
    
    func save(in card: Card) {
        LogRepository.shared.create(log: self, for: card)
    }
}
