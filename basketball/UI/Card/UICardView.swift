//
//  UICardView.swift
//  basketball
//
//  Created by Michael Vivar on 26/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import UIKit

class UICardView: UIView {

    var card: Card!
    
    weak var delegate: CardViewDelegate!
    weak var dataSource: CardViewDataSource! {
        didSet {
            self.card = self.dataSource.data()
            self.render()
        }
    }

    let headerView: UICardHeaderView = {
        return UICardHeaderView()
    }()
    
    let contentView: UICardContentView = {
        return UICardContentView()
    }()
}

extension UICardView {
    
    func render() {
        addSubviews(views: headerView, contentView)
        headerView.card = card
        contentView.delegate = self.delegate
        contentView.card = card
        
        styles()
        constraints()
    }
    
    private func styles() {
        headerView.backgroundColor = UIColor.blue()
        contentView.backgroundColor = UIColor.lightGray
    }
    
    private func constraints() {
        headerView.anchor(top: self.topAnchor, bottom: nil, left: self.leadingAnchor, right: self.trailingAnchor)
        headerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.125).isActive = true
        contentView.anchor(top: headerView.bottomAnchor, bottom: self.bottomAnchor, left: self.leadingAnchor, right: self.trailingAnchor, padding: .init(top: 0, left: 3, bottom: 3, right: 3))
    }
}

protocol CardViewDataSource: AnyObject {
    func data() -> Card
}

protocol CardViewDelegate: AnyObject {
    func didSelectSlot(slot: Slot, cell: UICardCellLabel)
}
