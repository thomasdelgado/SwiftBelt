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

    var pricePerMonth: Double {
        switch subscriptionPeriod?.unit {
        case .day:
            return price.doubleValue * 30
        case .week:
            return price.doubleValue * 4
        case .month:
            return price.doubleValue
        case .year:
            return price.doubleValue / 12
        case .none:
            return price.doubleValue
        @unknown default:
            return 0
        }
    }

    var localizedPricePerMonth: String {
        let formatter = NumberFormatter.currency
        formatter.locale = priceLocale
        return formatter.string(from: NSNumber(value: pricePerMonth)) ?? ""
    }

    var frequencyInMonths: String {
        switch subscriptionPeriod?.unit {
        case .month:
            let units = subscriptionPeriod?.numberOfUnits ?? 1
            if units == 1 {
                return "1 " + "month".localized()
            } else {
                return "\(units) \("months".localized())"
            }
        case .year:
            return "12 " + "months".localized()
        default:
            return ""
        }
    }

    func isComparableForDiscount(with product: SKProduct) -> Bool  {
        subscriptionGroupIdentifier == product.subscriptionGroupIdentifier &&
            subscriptionPeriod?.unit.rawValue ?? 0 > product.subscriptionPeriod?.unit.rawValue ?? 0 &&
            oneYearPrice < product.oneYearPrice
    }

    func discountBasedOn(_ product: SKProduct) -> String {
        String(format: "%.0f", (product.oneYearPrice - oneYearPrice) / product.oneYearPrice * 100 ) + "%"
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
