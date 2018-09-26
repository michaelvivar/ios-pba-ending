//
//  CardController.swift
//  basketball
//
//  Created by Michael Vivar on 26/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import UIKit

class CardController: UIViewController, CardViewDelegate, CardViewDataSource {
    
    deinit {
        print("De Init: CardController")
    }

    var card: Card!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideStatusBar()
        setupPanGesture()
        setupCardView()
        // Do any additional setup after loading the view.
    }
    
    let cardView: UICardView = {
        return UICardView()
    }()
    
    func setupCardView() {
        view.addSubviews(views: cardView)
        cardView.backgroundColor = UIColor.gray
        cardView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor)
        cardView.delegate = self
        cardView.dataSource = self
    }
    
    func data() -> Card {
        return card
    }
    
    func didSelectSlot(slot: Slot, cell: UICardCellLabel) {
        let action = slot.name.isEmpty ? Action.Add : Action.Update
        print(slot)
        
        let alert = UIAlertController(title: slot.number, message: card.game, preferredStyle: .alert)
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Name"
            textField.text = slot.name
        }
        
        setupSaveBtn(slot: slot, cell: cell, alert: alert, action: action)
        
        if (action == Action.Update) {
            setupPaidBtn(slot: slot, cell: cell, alert: alert)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func setupSaveBtn(slot: Slot, cell: UICardCellLabel, alert: UIAlertController, action: String) {
        let button = UIAlertAction(title: "OK", style: .default, handler: { [unowned self] a -> Void in
            let textField = alert.textFields![0] as UITextField
            let value = textField.text ?? ""
            
            if (slot.name == value) {
                return
            }
            cell.name = value
            
            if (action == Action.Add) {
                self.card = slot.save(in: self.card, name: value)
                cell.name = value
            }
            else {
                if (value.isEmpty) {
                    if (slot.paid == false) {
                        self.card = slot.delete(in: self.card)
                        cell.name = ""
                    }
                    return
                }
                else {
                    self.card = slot.update(in: self.card, name: value)
                    cell.name = value
                }
            }
        })
        alert.addAction(button)
    }
    
    func setupPaidBtn(slot: Slot, cell: UICardCellLabel, alert: UIAlertController) {
        
    }
    

    /*
    // MARK: - Navigation
    */

}

struct Action {
    static let Add: String = "add"
    static let Update: String = "update"
}


extension CardController {

    func setupPanGesture() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.onPan))
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc func onPan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        view.frame.origin = CGPoint(x: 0, y: (translation.y > 0 ? translation.y : 0))
        if (gesture.state == .ended) {
            let velocity = gesture.velocity(in: view)
            if (velocity.y >= 1200 || translation.y >= 150) {
                self.dismiss(animated: true, completion: {
                    self.showStatusBar()
                })
            }
            else {
                view.frame.origin = CGPoint(x: 0, y: 0)
            }
        }
    }
}
