//
//  System+Ext.swift
//  basketball
//
//  Created by Michael Vivar on 26/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import UIKit

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

extension String {
    func removeSpaces() -> String {
        return self.components(separatedBy: .whitespaces).joined()
    }

    func alphaNumeric() -> String {
        return self.components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
    }

    func strikeThrough() -> NSAttributedString {
        let attributedText: NSMutableAttributedString =  NSMutableAttributedString(string: self)
        attributedText.addAttributes([
            NSAttributedString.Key.strikethroughStyle:NSUnderlineStyle.single.rawValue, NSAttributedString.Key.strikethroughColor:UIColor.black],
                                     range: NSMakeRange(0, attributedText.length))
        return attributedText
    }
}
