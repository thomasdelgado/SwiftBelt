//
//  UINavigationController+Navigation.swift
//  
//
//  Created by Thomas Delgado on 04/02/21.
//

import UIKit

extension UINavigationController {
    public static func topViewController(
        base: UIViewController? = UIApplication.shared.getKeyWindow()?.rootViewController) -> UIViewController? {
        if let navigationController = base as? UINavigationController {
            return topViewController(base: navigationController.visibleViewController)

        } else if let tabBar = base as? UITabBarController, let selected = tabBar.selectedViewController {
            return topViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

extension UIApplication {
    public func getKeyWindow() -> UIWindow? {
        return UIApplication.shared.windows.filter { $0.isKeyWindow }.first
    }
}
