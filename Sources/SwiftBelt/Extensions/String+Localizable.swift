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
        localized(from: String.localizable)
    }

    func localized(from tableName: String) -> String {
        return NSLocalizedString(self, tableName: tableName.capitalized, value: self, comment: "")
    }
}
