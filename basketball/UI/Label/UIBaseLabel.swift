//
//  UIBaseLabel.swift
//  basketball
//
//  Created by Michael Vivar on 26/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import UIKit

class UIBaseLabel: UILabel {

    func font(size: CGFloat, color: UIColor, alignment: NSTextAlignment = NSTextAlignment.center) {
        self.font = UIFont(name: "DINCondensed-Bold", size: size)
        self.textColor = color
        self.textAlignment = alignment
    }
    
    func font(type font: String, size: CGFloat, color: UIColor, alignment: NSTextAlignment = NSTextAlignment.center) {
        self.font = UIFont(name: font, size: size)
        self.textColor = color
        self.textAlignment = alignment
    }
}
