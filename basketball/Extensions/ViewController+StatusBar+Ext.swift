//
//  ViewController+StatusBar+Ext.swift
//  basketball
//
//  Created by Michael Vivar on 24/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import UIKit

extension UIViewController {
    
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
