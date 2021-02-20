//
//  IAPHelper.swift
//  
//
//  Created by Thomas Delgado on 18/02/21.
//

import StoreKit
import Combine

@available(iOS 13.0, *)
public class IAPHelper: NSObject {
    public static let shared = IAPHelper(productIDs: [])
    public var productIdentifiers: Set<String>
    private var productsRequest: SKProductsRequest?
    private var publisher = PassthroughSubject<[SKProduct], Error>()
    public var transactionPublisher = PassthroughSubject<IAPTransactionState, Never>()
    public var purchasedProducts = Set<String>()
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

@available(iOS 13.0, *)
public extension IAPHelper {
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
}

@available(iOS 13.0, *)
extension IAPHelper: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        publisher.send(response.products)
        productsRequest = .none
    }

    public func request(_ request: SKRequest, didFailWithError error: Error) {
        publisher.send(completion: .failure(error))
        productsRequest = .none
    }
}

@available(iOS 13.0, *)
extension IAPHelper: SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { transaction in
            print(transaction)
            print(transaction.transactionState)
            switch transaction.transactionState {
            case .purchased:
                purchasedProducts.insert(transaction.payment.productIdentifier)
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionPublisher.send(.purchased(id: transaction.payment.productIdentifier))
            case .failed:
                let error = transaction.error ?? TransactionError.unknownError
                if let error = error as? SKError {
                    if error.code == .paymentCancelled { return }
                }
                transactionPublisher.send(.failed(error: error))
            case .deferred:
                //ask mom
                transactionPublisher.send(.deferred(id: transaction.payment.productIdentifier))
            case .purchasing: break
            case .restored:
                purchasesRestored += 1
                purchasedProducts.insert(transaction.payment.productIdentifier)
                SKPaymentQueue.default().finishTransaction(transaction)
            @unknown default: break
            }
        }
    }

    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        transactionPublisher.send(.restores(count: purchasesRestored))
    }

    public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        transactionPublisher.send(.failed(error: error))
//        if let error = error as? SKError {
//            if error.code == .paymentCancelled { return }
//        }
//        transactionPublisher.send(.failed(error: error))
//        if let error = error as? SKError {
//            if error.code != .paymentCancelled {
//                purchasePublisher.send(("IAP Restore Error: " + error.localizedDescription,false))
//            } else {
//                purchasePublisher.send(("IAP Error: " + error.localizedDescription,false))
//            }
//        }

    }
}

public enum IAPTransactionState {
    case purchased(id: String)
    case failed(error: Error)
    case deferred(id: String)
    case restores(count: Int)
}

enum TransactionError: Error {
    case unknownError
}
