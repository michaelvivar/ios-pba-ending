//
//  Controller+Extensions.swift
//  basketball
//
//  Created by Michael Vivar on 24/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import UIKit

extension UIViewController {

    func setTitle(title: String) {
        navigationItem.title = title
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor.blue()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
    }
    
    func setupNavigationBackButton(text: String = "", color: UIColor = UIColor.white) {
        let backButton = UIBarButtonItem()
        backButton.title = text
        backButton.tintColor = color
        navigationItem.backBarButtonItem = backButton
    }
    
    func navigate(page: Page, data: Card?) {
        setupNavigationBackButton()
        if (page == Page.Card) {
            let controller = CardController()
            if let card = data {
                controller.card = card
            }
            controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            present(controller, animated: true)
        }
        else if (page == Page.Logs) {
            let controller = LogsController()
            if let card = data {
                controller.card = card
            }
            navigationController?.pushViewController(controller, animated: true)
        }
        if let card = data {
            print(card.game)
        }
    }
}

enum Page {
    case Card
    case Logs
}
