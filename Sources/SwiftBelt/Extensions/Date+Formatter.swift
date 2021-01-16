//
//  Date+Formatter.swift
//  Budget
//
//  Created by Thomas Delgado on 01/06/20.
//  Copyright © 2020 Thomas Delgado. All rights reserved.
//

import Foundation

public extension Date {

    func formatDate(format: String? = nil) -> String {
        let formatter = DateFormatter()
        if let format = format {
            formatter.dateFormat = format
        } else {
            formatter.setLocalizedDateFormatFromTemplate("MMMMdd")
        }
        return formatter.string(from: self)
    }


    func formatDateTime() -> String {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMddHH:mm")
        return formatter.string(from: self)
    }
}
