//
//  System+Ext.swift
//  basketball
//
//  Created by Michael Vivar on 26/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import Foundation

extension Date {
    func format(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension Int {
    func formatWithComma() -> String {
        return String(format: "%d", locale: Locale.current, self)
    }
}
