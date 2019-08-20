//
//  CardController.swift
//  basketball
//
//  Created by Michael Vivar on 26/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import UIKit
import Firestore;

class CardController: BaseController, CardViewDelegate, CardViewDataSource {
    
    deinit {
        print("De Init: CardController")
        listener.remove();
    }

    var card: Card!
    var listener: FIRListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideStatusBar()
        setupPanGesture()
        setupCardView()
        // Do any additional setup after loading the view.
        addListener(card)
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
        
        if (action == Action.Update) {
            setupPaidBtn(slot: slot, cell: cell, alert: alert)
        }
        
        setupSaveBtn(slot: slot, cell: cell, alert: alert, action: action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func setupSaveBtn(slot: Slot, cell: UICardCellLabel, alert: UIAlertController, action: String) {
        let button = UIAlertAction(title: "OK", style: .default, handler: { [unowned self] a -> Void in
            let textField = alert.textFields![0] as UITextField
            let value = textField.text ?? ""
            
            if (slot.name == value) {
                return
            }
            
            if (action == Action.Add) {
                slot.save(in: self.card, name: value)
                cell.name = value
            }
            else {
                if (value.isEmpty) {
                    if (slot.paid == false) {
                        slot.delete(in: self.card)
                        cell.name = ""
                    }
                    return
                }
                else {
                    slot.update(for: self.card, name: value)
                    cell.name = value
                }
            }
        })
        alert.addAction(button)
    }
    
    func setupPaidBtn(slot: Slot, cell: UICardCellLabel, alert: UIAlertController) {
        if (slot.paid) {
            let button = UIAlertAction(title: "Unpaid", style: .destructive, handler: { [unowned self] (action : UIAlertAction!) -> Void in
                slot.unpaid(for: self.card)
                cell.paid = false
            })
            alert.addAction(button)
        }
        else {
            let button = UIAlertAction(title: "Paid", style: .default, handler: { [unowned self] (action : UIAlertAction!) -> Void in
                slot.paid(for: self.card)
                cell.paid = true
            })
            alert.addAction(button)
        }
    }
    
    private func addListener(_ card: Card) {
        listener = Store.firestore.document(card.id).collection("slots").addSnapshotListener({ [unowned self]
            snapshot, error in
            if let error = error {
                print(error)
            }
            else {
                if let snapshot = snapshot {
                    let slots: [Slot]? = snapshot.documents.compactMap({ doc in
                        let data = doc.data() as [String: Any]
                        guard let number = data["number"] as? String else { return nil }
                        guard let name = data["name"] as? String else { return nil }
                        guard let paid = data["paid"] as? Bool else { return nil }
                        guard let user = data["user"] as? String else { return nil }
                        let slot = Slot(number: number, name: name, paid: paid, user: user)
                        return slot
                    })
                    if let slots = slots {
                        self.cardView.contentView.reload(slots)
                        DataManager.save(slots, name: card.id, folder: "slots", completion: {})
                    }
                }
            }
        })
    }
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
