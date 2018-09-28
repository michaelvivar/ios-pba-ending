//
//  UIDateTimeLabel.swift
//  basketball
//
//  Created by Michael Vivar on 26/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import UIKit

class UIDateTimeLabel: UIBaseLabel {
    
    var date: Date! {
        didSet {
            if let time = time {
                let str = date.format("EEE") + " " + time + " - " + date.format("MMM dd")
                if (uppercase) {
                    self.text = str.uppercased()
                }
                else {
                    self.text = str
                }
            }
            else {
                self.text = (uppercase ? date.format(format).uppercased() : date.format(format))
            }
        }
    }
    
    var time: String?
    var format: String = "EEE - MMM dd, yyyy"
    var uppercase: Bool = true
}
