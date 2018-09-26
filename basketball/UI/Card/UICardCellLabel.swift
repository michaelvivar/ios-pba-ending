//
//  UICardCellLabel.swift
//  basketball
//
//  Created by Michael Vivar on 26/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import UIKit

class UICardCellLabel: UIBaseLabel {

    var name: String {
        get {
            return trim()
        }
        set {
            text = newValue.isEmpty ? "" : " " + newValue
            if (newValue.count > 7) {
                font = UIFont.systemFont(ofSize: 13)
            }
            else {
                font = UIFont.systemFont(ofSize: 15)
            }
        }
    }
    
    var paid: Bool {
        get {
            return self.backgroundColor != UIColor.white
        }
        set {
            self.backgroundColor = newValue ? UIColor.Hex("9AE27E") : UIColor.white
        }
    }

}

extension UICardCellLabel {

    private func trim() -> String {
        if let str: String = text {
            if str.hasPrefix(" ") {
                return str.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        return text ?? ""
    }
}
