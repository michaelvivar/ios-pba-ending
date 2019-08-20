//
//  UICardContentView.swift
//  basketball
//
//  Created by Michael Vivar on 26/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import UIKit

class UICardContentView: UIView {

    weak var delegate: CardViewDelegate!
    
    var card: Card! {
        didSet {
            render()
        }
    }
    
    func reload(_ slots: [Slot]) {
        cells.forEach({ cell in
            cell.value.cellLabel.name = ""
            cell.value.cellLabel.paid = false
        })
        slots.forEach({ [unowned self] slot in
            if let item = self.cells[slot.number] {
                item.cellLabel.name = slot.name
                item.cellLabel.paid = slot.paid
            }
        })
    }
    
    func render() {
        _topAnchor = topAnchor
        _leftAnchor = leftAnchor
        var count = 0
        repeat {
            let cell = generateCell(number: count)
            count = count + 1
            if (count == 25 || count == 50 || count == 75) {
                _topAnchor = topAnchor
                _leftAnchor = cell.rightAnchor
            }
            if (count == 100) {
                if let slots = card.slots {
                    reload(slots)
                }
            }
        } while count < 100
    }
    
    private var cells = Dictionary<String, UICardCellView>()
    private var _topAnchor: NSLayoutYAxisAnchor!
    private var _leftAnchor: NSLayoutXAxisAnchor!
    private let spacing: CGFloat = 3
    private let minHeight: CGFloat = 23
    
    private func generateCell(number: Int) -> UICardCellView {
        let cell = UICardCellView()
        addSubview(cell)
        cell.delegate = delegate
        cell.number = String("\(number > 10 ? number / 10 : (number == 10 ? 1 : 0))-\(number % 10)")
        let row = number > 24 ? number % 25 : number
        styles(cell)
        constraints(cell: cell, row: row)
        cells[cell.number] = cell
        return cell
    }
    
    private func styles(_ cell: UICardCellView) {
        cell.backgroundColor = UIColor.lightGray
    }
    
    private func constraints(cell: UICardCellView, row: Int) {
        cell.anchor2(top: _topAnchor, bottom: nil, left: _leftAnchor, right: nil,
                     padding: .init(top: (row == 5 || row == 15 ? 3 : 0), left: 0, bottom: 0, right: 0))
        cell.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25).isActive = true
        cell.heightAnchor.constraint(equalToConstant: height).isActive = true
        _topAnchor = cell.bottomAnchor
    }
    
    let height: CGFloat = ((UIScreen.main.bounds.height * 0.875) - (3 * 3)) / 25
}
