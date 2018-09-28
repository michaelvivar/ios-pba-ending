//
//  Application+Ext.swift
//  basketball
//
//  Created by Michael Vivar on 28/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import UIKit

extension UIApplication {
    
    class func activeController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            //return activeController(base: nav.visibleViewController)
            return activeController(base: nav.topViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return activeController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return activeController(base: presented)
        }
        return base
    }
    
    class func mainController<T: UIViewController>() -> T? {
        return UIApplication.shared.keyWindow?.rootViewController?.children[0] as? T
    }
}


extension UserDefaults {
    // check for is first launch - only true on first invocation after app install, false on all further invocations
    // Note: Store this value in AppDelegate if you have multiple places where you are checking for this flag
    static func isFirstLaunch() -> Bool {
        let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
        if (isFirstLaunch) {
            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
}
