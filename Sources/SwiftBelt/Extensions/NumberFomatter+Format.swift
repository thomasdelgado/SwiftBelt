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

    static var currency: NumberFormatter {
        let formatter = NumberFormatter()        
        formatter.numberStyle = .currency
        return formatter
    }

    static var currentCurrencyCode: String {
        return currency.currencyCode
    }
}
