//
//  File.swift
//  
//
//  Created by Thomas Delgado on 16/03/21.
//

import UIKit

public extension UIViewController {
    func displayAlert(title: String, message: String, action: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.view.tintColor = DesignSheet.primaryColor
        let action = UIAlertAction(title: "OK".localized(),
                                   style: .default,
                                   handler: action)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

    func displayConfirmationAlert(message: String,
                                  action: @escaping (UIAlertAction) -> Void) {
        displayConfirmationAlert(message: message,
                                 okTitle: "OK".localized(),
                                 cancelTitle: "Cancel".localized(),
                                 action: action)
    }

    func displayConfirmationAlert(title: String? = nil,
                                  message: String,
                                  okTitle: String,
                                  cancelTitle: String,
                                  action: @escaping (UIAlertAction) -> Void) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.view.tintColor = DesignSheet.primaryColor
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: action)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    func displayAlert(title: String? = nil,
                      message: String,
                      okMessage: String? = nil, action: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.view.tintColor = DesignSheet.primaryColor
        let action = UIAlertAction(title: okMessage != nil ? okMessage : "OK".localized(),
                                   style: .default,
                                   handler: action)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

    func displayConfirmationAlert(title: String? = nil,
                                  message: String,
                                  okTitle: String,
                                  cancelTitle: String,
                                  action: @escaping (UIAlertAction) -> Void,
                                  cancelAction: @escaping (UIAlertAction) -> Void) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.view.tintColor = DesignSheet.primaryColor
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: action)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelAction)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}
