//
//  UIButton+Appearance.swift
//  
//
//  Created by Thomas Delgado on 27/02/21.
//

import UIKit

extension UIButton {
    func setAppearanceFor(_ style: ButtonStyle) {
        radius = DesignSheet.cornerRadius
        titleLabel?.font = DesignSheet.Font.boldBody
        switch style {
        case .primary:
            borderWidth = .zero
            borderColor = .clear
            backgroundColor = DesignSheet.primaryColor
            setTitleColor(.white, for: .normal)
        case .disabled:
            setTitleColor(.white, for: .normal)
            backgroundColor = DesignSheet.disabledColor
        }
    }

    var adjustFontSizeToWidth: Bool {
        get {
            return titleLabel?.adjustsFontSizeToFitWidth ?? false
        }
        set {
            titleLabel?.numberOfLines = 1
            titleLabel?.adjustsFontSizeToFitWidth = newValue
            titleLabel?.lineBreakMode = .byClipping
            titleLabel?.baselineAdjustment = .alignCenters
        }
    }
}

extension UIButton {

    struct AssociatedKeys {
        static var activity: UInt8 = 0
        static var previousText: UInt8 = 0
    }

    private var activityIndicator: UIActivityIndicatorView? {
        get {
            guard let value =
                    objc_getAssociatedObject(self, &AssociatedKeys.activity) as? UIActivityIndicatorView else {
                return nil
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.activity,
                                     newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private var previousText: String? {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.previousText) as? String else {
                return nil
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.previousText,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public func startAnimating(activityColor: UIColor = .white) {
        if #available(iOS 13.0, *) {
            activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        } else {
            activityIndicator = UIActivityIndicatorView(style: .white)
        }
        activityIndicator?.color = activityColor
        activityIndicator?.startAnimating()
        activityIndicator?.tag = 99
        if let activityIndicator = self.viewWithTag(99) as? UIActivityIndicatorView {
            activityIndicator.removeFromSuperview()
        }
        if let activityIndicator = activityIndicator {
            fixSubview(activityIndicator)
        }
        previousText = titleLabel?.text
        setTitle("", for: .normal)
        isEnabled = false
    }

    public func stopAnimating() {
        activityIndicator?.removeFromSuperview()
        setTitle(previousText, for: .normal)
        isEnabled = true
    }
}

enum ButtonStyle {
    case primary
    case disabled
}
