//
//  UICardHeaderView.swift
//  basketball
//
//  Created by Michael Vivar on 26/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import UIKit

class UICardHeaderView: UIView {

    var card: Card! {
        didSet {
            render()
        }
    }
    
    let gameLabel: UIBaseLabel = {
        return UIBaseLabel()
    }()
    
    let dateLabel: UIDateTimeLabel = {
        return UIDateTimeLabel()
    }()
    
    let betLabel: UIBaseLabel = {
        return UIBaseLabel()
    }()
    
    let prizesLabel: UICardPrizesLabel = {
        return UICardPrizesLabel()
    }()

    func render() {
        addSubviews(views: gameLabel, dateLabel, betLabel, prizesLabel)
        dateLabel.format = "EEE - MMM dd"
        dateLabel.time = card.time
        dateLabel.date = card.date
        let peso: String = "\u{20B1}"
        betLabel.text = peso + " " + card.bet.formatWithComma()
        prizesLabel.prizes = card.prizes
        
        styles()
        constraints()
        
        if let visitor = card.teams["visitor"], let home = card.teams["home"] {
            let game = visitor.uppercased() + " vs " + home.uppercased()
            gameLabel.text = game
            gameLabel.lineBreakMode = .byClipping
            if (game.count > 30) {
                gameLabel.font(size: 21, color: UIColor.white)
            }
        }
    }
    
    private func styles() {
        gameLabel.font(type: "DINAlternate-Bold", size: 23, color: .white)
        dateLabel.font(size: 12, color: UIColor.white)
        betLabel.font(type: "DINAlternate-Bold", size: 20, color: .white)
        //prizesLabel.backgroundColor = UIColor.Hex("F56D03")
        prizesLabel.backgroundColor = UIColor.Hex("C62828")
        prizesLabel.font(type: "DINAlternate-Bold", size: 15, color: .white)
    }
    
    private func constraints() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -6).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
        gameLabel.anchor(top: nil, bottom: dateLabel.topAnchor, left: self.leadingAnchor, right: self.trailingAnchor)
        //gameLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        betLabel.anchor(top: dateLabel.bottomAnchor, bottom: nil, left: self.leadingAnchor, right: self.trailingAnchor)
        //betLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        prizesLabel.anchor(top: nil, bottom: self.bottomAnchor, left: self.leadingAnchor, right: self.trailingAnchor, padding: .zero, size: .init(width: 0, height: 20))
    }
}
