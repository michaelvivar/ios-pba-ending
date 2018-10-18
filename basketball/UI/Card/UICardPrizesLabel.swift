//
//  UICardPrizesLabel.swift
//  basketball
//
//  Created by Michael Vivar on 26/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import UIKit

class UICardPrizesLabel: UIBaseLabel {

    var prizes: Prizes! {
        didSet {
            self.text = self.format()
        }
    }

    func format() -> String {
        var items: [String] = [String]()
        items.append("1st: " + prizes.first.formatWithComma())
        items.append("2nd: " + prizes.second.formatWithComma())
        items.append("3rd: " + prizes.third.formatWithComma())
        items.append("4th: " + prizes.fourth.formatWithComma())
        if prizes.reverse > 0 {
            items.append("Rev: " + prizes.reverse.formatWithComma())
        }
        return items.joined(separator: " / ")
    }
}
