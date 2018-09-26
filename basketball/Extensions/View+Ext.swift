//
//  View+Ext.swift
//  basketball
//
//  Created by Michael Vivar on 26/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import UIKit

extension UIView {

    func addSubviews(views: UIView...) {
        // addArrangedSubviews if it's a UIStackView
        views.forEach { addSubview($0) }
    }
    
    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview()}
    }
    
    func safeRemove() {
        if let parent = superview {
            parent.subviews.forEach({ view in
                if (view == self) {
                    self.removeFromSuperview()
                }
            })
        }
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, right: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        if let left = left {
            leadingAnchor.constraint(equalTo: left, constant: padding.left).isActive = true
        }
        if let right = right {
            trailingAnchor.constraint(equalTo: right, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}
