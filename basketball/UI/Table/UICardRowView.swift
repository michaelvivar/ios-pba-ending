//
//  UICardRowView.swift
//  basketball
//
//  Created by Michael Vivar on 26/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import UIKit

class UICardRowView: UITableRowView<Card> {
    
    var delegate: UICardRowDelegate!
    
    var card: Card!
    
    @objc func handleTap() {
        delegate.didSelectRow(card: self.card)
    }
    
    override func render() {
        card = item
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap)))
        self.backgroundColor = UIColor.Hex("EEEEEE")
        self.addSubview(containerView)
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 1, height: 1)
        containerView.layer.shadowRadius = 1
        containerView.layer.shadowOpacity = 0.2
        containerView.backgroundColor = UIColor.white
        containerView.addSubview(dateLabel)
        containerView.addSubview(betLabel)
        containerView.addSubview(visitorLabel)
        containerView.addSubview(versusLabel)
        containerView.addSubview(homeLabel)
        containerView.addSubview(progressView)
        styles()
        constraints()
        
        dateLabel.format = "- EEE MMM dd"
        dateLabel.time = self.card.time
        dateLabel.date = self.card.date
        let peso: String = "\u{20B1}"
        betLabel.text = peso + " " + self.card.bet.formatWithComma()
        visitorLabel.text = self.card.teams["visitor"]
        versusLabel.text = "vs"
        homeLabel.text = self.card.teams["home"]
        progressView.setProgress(Float(card.progress) / 100, animated: true)
    }
    
    private func styles() {
        dateLabel.font = UIFont(name: "DINCondensed-Bold", size: 12)
        dateLabel.textAlignment = .right
        dateLabel.textColor = UIColor.orange()
        betLabel.font(size: 14, color: UIColor.blue(), alignment: .right)
        visitorLabel.font(size: 17, color: UIColor.blue())
        versusLabel.font(size: 12, color: UIColor.blue())
        homeLabel.font(size: 17, color: UIColor.blue())
        progressView.progressTintColor = UIColor.orange()
        progressView.trackTintColor = UIColor.blue()
        progressView.progress = Float(0)
        
        if (card.status == false) {
            dateLabel.textColor = UIColor.lightGray
            betLabel.textColor = UIColor.lightGray
            visitorLabel.textColor = UIColor.lightGray
            versusLabel.textColor = UIColor.lightGray
            homeLabel.textColor = UIColor.lightGray
            progressView.progressTintColor = UIColor.gray
            progressView.trackTintColor = UIColor.lightGray
        }
    }

    private func constraints() {
        containerView.anchor(top: self.topAnchor, bottom: self.bottomAnchor, left: self.leadingAnchor, right: self.trailingAnchor, padding: .init(top: 5, left: 0, bottom: 5, right: 0))
        dateLabel.anchor(top: containerView.topAnchor, bottom: nil, left: containerView.leadingAnchor, right: containerView.trailingAnchor, padding: .init(top: 5, left: 0, bottom: 0, right: 10))
        betLabel.anchor(top: containerView.topAnchor, bottom: nil, left: containerView.leadingAnchor, right: nil, padding: .init(top: 5, left: 10, bottom: 0, right: 0))
        versusLabel.anchor(top: nil, bottom: nil, left: containerView.leadingAnchor, right: containerView.trailingAnchor, padding: .zero, size: .zero)
        versusLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        visitorLabel.anchor(top: nil, bottom: versusLabel.topAnchor, left: containerView.leadingAnchor, right: containerView.trailingAnchor, padding: .zero, size: .zero)
        homeLabel.anchor(top: versusLabel.bottomAnchor, bottom: nil, left: containerView.leadingAnchor, right: containerView.trailingAnchor, padding: .init(top: 2, left: 0, bottom: 0, right: 0), size: .zero)
        progressView.anchor(top: nil, bottom: containerView.bottomAnchor, left: containerView.leadingAnchor, right: containerView.trailingAnchor, padding: .init(top: 0, left: 10, bottom: 5, right: 10))
    }
    
    let containerView: UIView = {
        return UIView()
    }()
    
    let homeLabel: UIBaseLabel = {
        return UIBaseLabel()
    }()
    
    let visitorLabel: UIBaseLabel = {
        return UIBaseLabel()
    }()
    
    let versusLabel: UIBaseLabel = {
        return UIBaseLabel()
    }()
    
    let dateLabel: UIDateTimeLabel = {
        return UIDateTimeLabel()
    }()
    
    let betLabel: UIBaseLabel = {
        return UIBaseLabel()
    }()
    
    let progressView: UIProgressView = {
        return  UIProgressView()
    }()
}

protocol UICardRowDelegate {
    func didSelectRow(card: Card)
}
