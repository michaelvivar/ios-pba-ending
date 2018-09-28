//
//  UILogRowView.swift
//  basketball
//
//  Created by Michael Vivar on 26/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import UIKit

class UILogRowView: UITableRowView<Log> {
    
    var log: Log!
    
    
    override func render() {
        log = item
        self.addSubviews(views: numberLabel, containerView)
        containerView.addSubviews(views: nameLabel, dateLabel, actionLabel)
        styles()
        constraints()
        numberLabel.text = log.data.number
        
        dateLabel.format = "EEE hh:mm a"
        dateLabel.date = log.date
        actionLabel.text = log.action.uppercased()
        if (log.action == "Update") {
            let names = log.data.name.components(separatedBy: " > ")
            if let old = names.first, let new = names.last {
                nameLabel.setStrikethrough(text: old, with: new)
            }
        }
        else {
            nameLabel.text = log.data.name
        }
    }
    
    private func styles() {
        backgroundColor = UIColor.Hex("EEEEEE")
        if (log.action == "Delete"){
            numberLabel.backgroundColor = UIColor.Hex("E23729")
        }
        else if (log.action == "Paid") {
            numberLabel.backgroundColor = UIColor.Hex("82C57A")
        }
        else if (log.action == "Unpaid") {
            numberLabel.backgroundColor = UIColor.Hex("E57642")
        }
        else if (log.action == "Update") {
            numberLabel.backgroundColor = UIColor.Hex("136F9A")
        }
        else {
            numberLabel.backgroundColor = UIColor.Hex("136F9A")
        }
        nameLabel.textColor = UIColor.gray
        numberLabel.font(size: 20, color: UIColor.white)
        containerView.backgroundColor = UIColor.white
        dateLabel.font(size: 11, color: UIColor.lightGray, aligment: .right)
        actionLabel.font(size: 11, color: UIColor.lightGray, aligment: .right)
    }
    
    private func constraints() {
        numberLabel.anchor(top: self.topAnchor, bottom: self.bottomAnchor, left: self.leadingAnchor, right: nil, padding: .init(top: 0, left: 0, bottom: 1, right: 0), size: .init(width: 35, height: 0))
        containerView.anchor(top: self.topAnchor, bottom: self.bottomAnchor, left: numberLabel.trailingAnchor, right: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 1, right: 0))
        nameLabel.anchor(top: containerView.topAnchor, bottom: containerView.bottomAnchor, left: containerView.leadingAnchor, right: containerView.trailingAnchor, padding: .init(top: 0, left: 10, bottom: 0, right: 0))
        dateLabel.anchor(top: containerView.topAnchor, bottom: nil, left: nil, right: containerView.trailingAnchor, padding: .init(top: 2, left: 0, bottom: 0, right: 5))
        actionLabel.anchor(top: nil, bottom: containerView.bottomAnchor, left: nil, right: containerView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 2, right: 5))
    }
    
    let containerView: UIView = {
        return UIView()
    }()
    
    let numberLabel: UIBaseLabel = {
        return UIBaseLabel()
    }()
    
    let nameLabel: UIBaseLabel = {
        return UIBaseLabel()
    }()
    
    let dateLabel: UIDateTimeLabel = {
        return UIDateTimeLabel()
    }()
    
    let actionLabel: UIBaseLabel = {
        return UIBaseLabel()
    }()
    
    let borderBottom: UIView = {
        return UIView()
    }()
    
}
