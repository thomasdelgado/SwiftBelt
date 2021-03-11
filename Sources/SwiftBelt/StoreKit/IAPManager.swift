//
//  IAPHelper.swift
//  
//
//  Created by Thomas Delgado on 18/02/21.
//

import StoreKit
import Combine

public class IAPManager: NSObject {
    public static let shared = IAPManager(productIDs: [])
    public var productIdentifiers: Set<String>
    private var productsRequest: SKProductsRequest?
    private var publisher = PassthroughSubject<[SKProduct], Error>()
    public var transactionPublisher = PassthroughSubject<IAPTransactionState, Never>()
    public var purchasedProducts = Set<String>()
    public var waitingForApproval = Set<String>()
    public var purchasesRestored = 0

    public init(productIDs: Set<String>) {
        productIdentifiers = productIDs
        super.init()
    }

    public func startObserving() {
        SKPaymentQueue.default().add(self)
    }

    public func stopObserving() {
        SKPaymentQueue.default().remove(self)
    }
}

public extension IAPManager {
    func buyProduct(_ product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    func fetchProducts() -> PassthroughSubject<[SKProduct], Error> {
        productsRequest?.cancel()
        publisher = PassthroughSubject<[SKProduct], Error>()
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
        return publisher
    }

    func restore() {
        purchasesRestored = 0
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    func save(_ transaction: SKPaymentTransaction) {
        purchasedProducts.insert(transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}

extension IAPManager: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        publisher.send(response.products)
        productsRequest = .none
    }

    public func request(_ request: SKRequest, didFailWithError error: Error) {
        publisher.send(completion: .failure(error))
        productsRequest = .none
    }
}

extension IAPManager: SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { transaction in
            waitingForApproval.remove(transaction.payment.productIdentifier)            
            switch transaction.transactionState {
            case .purchased:
                save(transaction)
                transactionPublisher.send(.purchased(id: transaction.payment.productIdentifier))
            case .failed:
                let error = transaction.error ?? TransactionError.unknownError
                if let error = error as? SKError {
                    if error.code == .paymentCancelled {
                        transactionPublisher.send(.canceled)
                        return
                    }
                }
                transactionPublisher.send(.failed(error: error))
            case .deferred:
                waitingForApproval.insert(transaction.payment.productIdentifier)
                transactionPublisher.send(.deferred(id: transaction.payment.productIdentifier))
            case .purchasing: break
            case .restored:
                purchasesRestored += 1
                save(transaction)
            @unknown default: break
            }
        }
    }

    public func paymentQueue(_ queue: SKPaymentQueue, didRevokeEntitlementsForProductIdentifiers productIdentifiers: [String]) {
        purchasedProducts.forEach { purchasedProducts.remove($0) }
        transactionPublisher.send(.reinvoked)
    }

    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        transactionPublisher.send(.restores(count: purchasesRestored))
    }

    public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        transactionPublisher.send(.failed(error: error))
    }
}

//MARK: - subscriptions
public extension IAPManager {
    func isSubscriptionValid(_ receipt: ReceiptInfo, pendingInfo: [PendingRenewalInfo]) -> Bool {
        guard let expirationDate = receipt.expirationDate,
              !receipt.isCanceled else { return false }

        //validate grace period
        let pendingInfo = pendingInfo.first { $0.original_transaction_id == receipt.original_transaction_id }
        if let pendingInfo = pendingInfo,
           let gracePeriod = pendingInfo.gracePeriodDate,
           gracePeriod > Date() {
            return true
        }

        return Date() <= expirationDate
    }
}

public enum IAPTransactionState {
    case purchased(id: String)
    case failed(error: Error)
    case deferred(id: String)
    case restores(count: Int)
    case canceled
    case reinvoked

    public func status() -> String {
        switch self {
        case .purchased:
            return "purchased"
        case .failed:
            return "failed"
        case .deferred:
            return "deferred"
        case .restores:
            return "restore"
        case .canceled:
            return "canceled"
        case .reinvoked:
            return "reinvoked"
        }
    }
}

enum TransactionError: Error {
    case unknownError
}
