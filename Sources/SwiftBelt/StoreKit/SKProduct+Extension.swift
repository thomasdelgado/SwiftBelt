//
//  File.swift
//  
//
//  Created by Thomas Delgado on 25/02/21.
//

import StoreKit

public extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter.currency
        formatter.locale = priceLocale
        return formatter.string(from: price) ?? ""
    }

    var subscriptionOffer: String {
        "\(localizedPrice) / \(subscriptionPeriod?.unit.stringValue.capitalized ?? "")"
    }

    var subscriptionFrequency: String {
        subscriptionPeriod?.unit.frequencyValue ?? ""
    }

    var hasTrialPeriod: Bool {
        introductoryPrice?.paymentMode == .freeTrial
    }

    var trialOffer: String {
        guard introductoryPrice?.price == 0,
              let numberOfPeriods = introductoryPrice?.numberOfPeriods,
              let unit = introductoryPrice?.subscriptionPeriod.unit.stringValue else {
            return ""
        }
        let offer = "free trial".localized()
        return "\(numberOfPeriods) \(unit) \(offer)."
    }

    var oneYearPrice: Double {
        switch subscriptionPeriod?.unit {
        case .day:
            return 365 * price.doubleValue
        case .week:
            return 52 * price.doubleValue
        case .month:
            return 12 * price.doubleValue
        case .year:
            return price.doubleValue
        case .none:
            return price.doubleValue
        @unknown default:
            return 0
        }
    }
}

extension SKProduct.PeriodUnit {
    var stringValue: String {
        switch self {
        case .day:
            return "day".localized()
        case .month:
            return "month".localized()
        case .year:
            return "year".localized()
        case .week:
            return "week".localized()
        @unknown default:
            return ""
        }
    }

    var frequencyValue: String {
        switch self {
        case .day:
            return "daily"
        case .month:
            return "monthly"
        case .year:
            return "yearly"
        case .week:
            return "weekly"
        @unknown default:
            return ""
        }
    }
}
