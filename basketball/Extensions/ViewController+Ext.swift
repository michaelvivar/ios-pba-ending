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
    
    func hideStatusBar() {
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.isHidden = true
        statusBar.layer.isHidden = true
    }
    
    func showStatusBar() {
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.isHidden = false
        statusBar.layer.isHidden = false
    }
}
