//
//  String+Localizable.swift
//  
//
//  Created by Thomas Delgado on 06/02/21.
//

import Foundation

public extension String {
    static let localizable = "localizable"

    func localized() -> String {
        localized(fromFile: String.localizable)
    }

    func localized(fromFile file: String) -> String {
        return NSLocalizedString(self, tableName: file.capitalized, value: self, comment: "")
    }
}
