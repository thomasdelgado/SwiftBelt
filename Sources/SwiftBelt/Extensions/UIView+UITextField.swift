//
//  File.swift
//  
//
//  Created by Thomas Delgado on 27/02/21.
//

import UIKit

extension UIView {
    var textFieldsInView: [UITextField] {
        return subviews
            .filter({ !($0 is UITextField) })
            .reduce(( subviews.compactMap { $0 as? UITextField }), { summ, current in
                return summ + current.textFieldsInView
            })
    }

    var textViewsInView: [UITextView] {
        return subviews
            .filter({ !($0 is UITextView) })
            .reduce(( subviews.compactMap { $0 as? UITextView }), { summ, current in
                return summ + current.textViewsInView
            })
    }

    var activeTextField: UITextField? {
        return textFieldsInView.filter { $0.isFirstResponder }.first
    }

    var activeTextView: UITextView? {
        return textViewsInView.filter { $0.isFirstResponder }.first
    }
}
