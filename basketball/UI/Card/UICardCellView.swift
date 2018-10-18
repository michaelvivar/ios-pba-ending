//
//  UICardSlotView.swift
//  basketball
//
//  Created by Michael Vivar on 26/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import UIKit

class UICardCellView: UIView {
    
    weak var delegate: CardViewDelegate!
    
    var number: String! {
        didSet {
            render()
        }
    }
    
    let numberLabel: UIBaseLabel = {
        return UIBaseLabel()
    }()
    
    let cellLabel: UICardCellLabel = {
        return UICardCellLabel()
    }()
    
    private func render() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        addSubviews(views: numberLabel, cellLabel)
        numberLabel.text = number
        cellLabel.paid = false
        
        styles()
        constraints()
    }
    
    private func styles() {
        numberLabel.backgroundColor = UIColor.blue()
        numberLabel.font(size: 13, color: UIColor.white)
        cellLabel.lineBreakMode = .byClipping
        cellLabel.backgroundColor = UIColor.white
        cellLabel.font(type: "DINAlternate-Bold", size: 13, color: UIColor.black, alignment: .left)
    }
    
    private func constraints() {
        numberLabel.anchor(top: self.topAnchor, bottom: self.bottomAnchor, left: self.leadingAnchor, right: nil, padding: .zero, size: .init(width: 19, height: 0))
        cellLabel.anchor(top: self.topAnchor, bottom: self.bottomAnchor, left: numberLabel.trailingAnchor, right: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 1, right: 0), size: .zero)
    }
    
    @objc private func handleTap() {
        let slot = Slot(number: number, name: cellLabel.name, paid: cellLabel.paid, user: "admin")
        delegate.didSelectSlot(slot: slot, cell: cellLabel)
    }
}

extension UICardCellView {
    
    func anchor2(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, right: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: padding.left).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}
