//
//  Color+Extensions.swift
//  basketball
//
//  Created by Michael Vivar on 24/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func Hex(_ value: String) -> UIColor {
        var str = value.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if str.hasPrefix("#") {
            str.remove(at: str.startIndex)
        }
        if str.count != 6 {
            return UIColor.black
        }
        
        var rgb: UInt32 = 0
        Scanner(string: str).scanHexInt32(&rgb)
        
        return UIColor.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
    
    class func Image(_ image: String) -> UIColor {
        return UIColor(patternImage: UIImage(named: image)!)
    }
    
    class func blue() -> UIColor {
        return UIColor.Hex("032E50")
    }
    
    class func orange() -> UIColor {
        return UIColor.Hex("CA4E34")
    }
}
