//
//  String+Utils.swift
//  Budget
//
//  Created by Thomas Delgado on 04/06/20.
//  Copyright © 2020 Thomas Delgado. All rights reserved.
//

import Foundation

public extension String {
    func onlyNumbers() -> String {
        guard !isEmpty else { return "" }
        return replacingOccurrences(of: "\\D",
                                    with: "",
                                    options: .regularExpression,
                                    range: startIndex..<endIndex)
    }

    func convertToDouble() -> Double? {
        NumberFormatter().number(from: self)?.doubleValue
    }
}
