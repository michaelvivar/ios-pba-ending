//
//  Label+Ext.swift
//  basketball
//
//  Created by Michael Vivar on 26/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import UIKit

extension UILabel {
    func setStrikethrough(text:String, with: String, color:UIColor = UIColor.Hex("424242")) {
        let mutableAttributedString = NSMutableAttributedString()
        let attributedText = NSAttributedString(string: text , attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.strikethroughColor: color])
        
        mutableAttributedString.append(attributedText)
        mutableAttributedString.append(NSAttributedString(string: " " + with))
        self.attributedText = mutableAttributedString
    }
    
    func setLineHeight(lineHeight: CGFloat) {
        let text = self.text
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            
            style.lineSpacing = lineHeight
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, text.count))
            self.attributedText = attributeString
        }
    }
}
