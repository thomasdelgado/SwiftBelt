//
//  AppStoreReceipt.swift
//  
//
//  Created by Thomas Delgado on 24/02/21.
//

import Foundation
/*
 Object based on the following json https://developer.apple.com/documentation/appstorereceipts/responsebody
 */

public class AppStoreReceipt: Codable {
    public var environment: String
    public var latest_receipt: String?
    public var status: Int
    public var latest_receipt_info: [ReceiptInfo]?
    public var pending_renewal_info: [PendingRenewalInfo]?
    public var isReceiptValid: Bool { status == 0 }
}

public class ReceiptInfo: Codable {
    public var product_id: String
    public var transaction_id: String
    public var original_transaction_id: String?
    public var cancellation_date: String?
    public var subscription_group_identifier: String?
    public var is_trial_period: String?
    public var expires_date_ms: String?
    public var original_purchase_date_ms: String?
    public var purchase_date_ms: String?

    public var isCanceled: Bool {
        cancellation_date != nil
    }

    public var expirationDate: Date? {
        guard let interval = TimeInterval(expires_date_ms ?? "") else {
            return nil
        }

        return Date(timeIntervalSince1970: interval / 1000.0)
    }

    public var purchaseDate: Date? {
        guard let interval = TimeInterval(purchase_date_ms ?? "") else {
            return nil
        }

        return Date(timeIntervalSince1970: interval / 1000.0)
    }
}

public class PendingRenewalInfo: Codable {
    public var expiration_intent: String?
    public var grace_period_expires_date_ms: String?
    public var is_in_billing_retry_period: String?
    public var original_transaction_id: String?
    
    public var gracePeriodDate: Date? { 
        guard let interval = TimeInterval(grace_period_expires_date_ms  ?? "") else {
            return nil
        }

        return Date(timeIntervalSince1970: interval / 1000.0)
    }
}
