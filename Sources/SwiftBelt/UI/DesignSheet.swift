//
//  DesignSheet.swift
//  
//
//  Created by Thomas Delgado on 27/02/21.
//

import UIKit

public struct DesignSheet {
    static public var cornerRadius: CGFloat = 6
    static public var primaryColor: UIColor = .blue
    static public var disabledColor: UIColor = .systemGray2
    static public var borderColor: UIColor = .systemGray3

    public struct Font {
        public static var body: UIFont = UIFont.preferredFont(forTextStyle: .body)
        public static var boldBody: UIFont = UIFont.boldSystemFont(ofSize:  UIFont.preferredFont(forTextStyle: .body).pointSize)
        public static var headline: UIFont = UIFont.preferredFont(forTextStyle: .headline)
    }
}

