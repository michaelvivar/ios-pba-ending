//
//  UICardCellLabel.swift
//  basketball
//
//  Created by Michael Vivar on 26/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import UIKit

class UICardCellLabel: UIBaseLabel {
    
    override func drawText(in rect:CGRect) {
        guard let labelText = text else {  return super.drawText(in: rect) }
        
        let attributedText = NSAttributedString(string: labelText, attributes: [NSAttributedString.Key.font: font])
        var newRect = rect
        newRect.size.height = attributedText.boundingRect(with: rect.size, options: .usesLineFragmentOrigin, context: nil).size.height
        
        if numberOfLines != 0 {
            //newRect.size.height = min(newRect.size.height, CGFloat(numberOfLines) * font.lineHeight)
        }
        
        newRect.size.height = 25
        
        super.drawText(in: newRect)
    }

    var name: String {
        get {
            return trim()
        }
        set {
            text = newValue.isEmpty ? "" : " " + newValue
            if (newValue.count > 12) {
                font(size: 13, color: UIColor.black, alignment: .left)
            }
            else {
                font(size: 15, color: UIColor.black, alignment: .left)
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
