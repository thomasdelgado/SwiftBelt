//
//  File.swift
//  
//
//  Created by Thomas Delgado on 27/02/21.
//

import UIKit

class BaseViewController: UIViewController {
    var viewOrigin: CGFloat = 0
    var keyboardVisibleHeight: CGFloat = 0
    var alwaysMoveKeyboard: Bool = false
    var tapGesture: UITapGestureRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        if let tapGesture = tapGesture {
            view.addGestureRecognizer(tapGesture)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setKeyboardHandler()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unsetKeyboardHandler()
    }

    // MARK: GESTURE
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        view.endEditing(false)
    }

    func removeKeyboardTapGesture() {
        if let tapGesture = tapGesture {
            view.removeGestureRecognizer(tapGesture)
        }
    }
}

extension BaseViewController {
    func setKeyboardHandler() {
        viewOrigin = view.frame.origin.y
        NotificationCenter.default.addObserver(self,
                                               selector:
                                                #selector(KeyboardLayoutConstraint.keyboardWillShowNotification(_:)),
                                               name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector:
                                                #selector(KeyboardLayoutConstraint.keyboardWillHideNotification(_:)),
                                               name: UIWindow.keyboardWillHideNotification, object: nil)
    }

    func unsetKeyboardHandler() {
        NotificationCenter.default.removeObserver(self)
    }

    func moveScreen() {
        view.frame.origin.y = viewOrigin - keyboardVisibleHeight
    }

    @objc func keyboardWillShowNotification(_ notification: UIKit.Notification) {
        if let userInfo = notification.userInfo {
            if let frameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let frame = frameValue.cgRectValue
                keyboardVisibleHeight = frame.size.height
                if let fixedKeyboardOffset = fixedKeyboardOffset {
                    keyboardVisibleHeight = fixedKeyboardOffset
                }

                var aRect: CGRect = view.frame
                aRect.origin.y = CGFloat.zero
                aRect.size.height -= keyboardVisibleHeight
                if let activeField = view.activeTextField ?? view.activeTextView {
                    if alwaysMoveKeyboard {
                        moveScreen()
                    } else {
                        if !aRect.contains(activeField.frame) {
                            moveScreen()
                        }
                    }
                }
            }
        }
    }

    @objc func keyboardWillHideNotification(_ notification: NSNotification) {
        keyboardVisibleHeight = CGFloat.zero
        moveScreen()
    }
}

