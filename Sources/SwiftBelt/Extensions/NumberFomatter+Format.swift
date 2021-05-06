//
//  NumberFomatter+Format.swift
//  Budget
//
//  Created by Thomas Delgado on 31/05/20.
//  Copyright © 2020 Thomas Delgado. All rights reserved.
//

import Foundation

public extension NumberFormatter {

    static func formatCurrency(_ value: Double) -> String {
        currency.string(for: value) ?? ""
    }

    static func formatCurrencyWithoutSymbol(_ value: Double) -> String {
        currency.string(for: value)?
            .replacingOccurrences(of: currency.negativePrefix, with: "")
            .replacingOccurrences(of: currency.positivePrefix, with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)  ?? ""
    }

    static var currency: NumberFormatter {
        let formatter = NumberFormatter()        
        formatter.numberStyle = .currency
        return formatter
    }

    static var currentCurrencyCode: String {
        return currency.currencyCode
    }
}

public extension Double {
    func formatCurrency() -> String {
        NumberFormatter.formatCurrency(self)
    }

    func formatCurrencyWithoutSymbol() -> String {
        NumberFormatter.formatCurrencyWithoutSymbol(self)
    }

    func currencyPrefix() -> String {
        if self < 0 {
            return NumberFormatter.currency.negativePrefix
                .trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            return NumberFormatter.currency.positivePrefix
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
}
