//
//  BaseController.swift
//  basketball
//
//  Created by Michael Vivar on 24/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import UIKit

class BaseController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
    }
    
    func navigate(page: Page, data: Card?) {
        setupNavigationBackButton()
        if (page == Page.Card) {
            let controller = CardController()
            if let card = data {
                SlotRepository.shared.read(for: card, completion: { slots in
                    controller.card = card.clone(with: slots)
                })
            }
            controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            //controller.modalTransitionStyle = .crossDissolve
            present(controller, animated: true)
        }
        else if (page == Page.Logs) {
            let controller = LogsController()
            if let card = data {
                LogRepository.shared.read(for: card, completion: { logs in
                    controller.card = card.clone(with: logs)
                })
            }
            navigationController?.pushViewController(controller, animated: true)
        }
        else if (page == Page.Form) {
            let controller = FormController()
            if let card = data {
                controller.card = card
            }
            navigationController?.pushViewController(controller, animated: true)
        }
        if let card = data {
            print("Load: ", card.game)
        }
    }
}

enum Page {
    case Card
    case Logs
    case Form
}
