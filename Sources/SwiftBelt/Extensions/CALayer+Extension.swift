//
//  File 2.swift
//  
//
//  Created by Thomas Delgado on 27/02/21.
//
import UIKit

// MARK: Animations
public extension CALayer {

    func animatedSelectionWith(selectionColor: CGColor) {
        let animation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.borderColor))
        animation.fromValue = borderColor
        animation.toValue = selectionColor
        animation.duration = 0.3
        borderColor = selectionColor
        add(animation, forKey: #keyPath(CAGradientLayer.borderColor))
    }

}
