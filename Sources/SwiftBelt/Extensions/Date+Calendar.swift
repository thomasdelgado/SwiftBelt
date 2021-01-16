//
//  Date+Calendar.swift
//  Budget
//
//  Created by Thomas Delgado on 07/06/20.
//  Copyright © 2020 Thomas Delgado. All rights reserved.
//

import Foundation

public extension Date {

    func daysBetween(date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: self, to: date).day!
    }

    var onlyDate: Date {
        get {
            let calender = Calendar.current
            var dateComponents = calender.dateComponents([.year, .month, .day], from: self)
            dateComponents.timeZone = NSTimeZone.system
            return calender.date(from: dateComponents) ?? Date()
        }
    }

    var firstDayOfMonth: Date {
        get {
            let calender = Calendar.current
            var dateComponents = calender.dateComponents([.year, .month, .day], from: self)
            dateComponents.timeZone = NSTimeZone.system
            dateComponents.day = 1
            return calender.date(from: dateComponents) ?? Date()
        }
    }
}
