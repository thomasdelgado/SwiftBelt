//
//  DesignSheet.swift
//  
//
//  Created by Thomas Delgado on 27/02/21.
//

import UIKit

public struct DesignSheet {
    static var cornerRadius: CGFloat = 6
    static var primaryColor: UIColor = .blue
    static var disabledColor: UIColor = .systemGray2
    static var borderColor: UIColor = .systemGray3

    struct Font {
        static var body: UIFont = UIFont.preferredFont(forTextStyle: .body)
        static var boldBody: UIFont = UIFont.boldSystemFont(ofSize:  UIFont.preferredFont(forTextStyle: .body).pointSize)
        static var headline: UIFont = UIFont.preferredFont(forTextStyle: .headline)
    }

    
}
