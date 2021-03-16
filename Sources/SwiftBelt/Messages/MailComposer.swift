//
//  File.swift
//  
//
//  Created by Thomas Delgado on 16/03/21.
//

import Foundation
import MessageUI

public class MailComposer: NSObject, MFMailComposeViewControllerDelegate {
    var recipients = [String]()
    var subject: String
    var message: String

    public init(recipients: [String] = [], subject: String, message: String) {
        self.recipients = recipients
        self.subject = subject
        self.message = message
    }

    public func getComposerController() -> MFMailComposeViewController? {
        if !MFMailComposeViewController.canSendMail() {
            return nil
        }

        let composer = MFMailComposeViewController()
        // Configure the fields of the interface.
        composer.setToRecipients(recipients)
        composer.setSubject(subject)
        composer.setMessageBody(message, isHTML: false)
        return composer
    }

    public func present() -> Bool {
        guard let composer = getComposerController() else {
            return false
        }

        composer.mailComposeDelegate = self
        composer.delegate = self
        UINavigationController.topViewController()?.present(composer, animated: true, completion: nil)
        return true
    }


}

extension MailComposer: UINavigationControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error {
            UINavigationController.topViewController()?.displayAlert(message: error.localizedDescription, action: nil)
            return
        }

        controller.dismiss(animated: true, completion: nil)
    }
}

