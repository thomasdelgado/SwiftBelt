//
//  UIView+Layout.swift
//  
//
//  Created by Thomas Delgado on 27/02/21.
//

import UIKit

public extension UIView {
    enum CircleOptions {
        case width
        case height
    }
    
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    func setAsCircle(using option: CircleOptions = .width) {
        switch option {
        case .width:
            cornerRadius = self.frame.width / 2
        case .height:
            cornerRadius = self.frame.height / 2
        }
    }

    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }

    func fixSubview(_ subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subview.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            subview.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            subview.widthAnchor.constraint(equalTo: self.widthAnchor),
            subview.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
}
