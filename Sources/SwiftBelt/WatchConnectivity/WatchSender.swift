//
//  WatchSender.swift
//  Watch Extension
//
//  Created by Thomas Delgado on 24/03/21.
//  Copyright © 2021 Thomas Delgado. All rights reserved.
//

import Foundation
import WatchConnectivity
import os
import Combine

public class WatchSender {
    public let logger = Logger(subsystem: "com.delgado.swiftbelt", category: "Watch Sender")
    public static let shared = WatchSender()
    public var lastComplicationSentDate: Date?
    public var queuedComplication: [String: Any]?
    var cancellable: AnyCancellable?
    public var isAbleToSendMessages: Bool {
        WCSession.default.activationState == .activated && WCSession.default.isReachable
    }
    public let complicationPublisher = PassthroughSubject<[String: Any], Never>()

    init() {
        setComplicationSubscriber()
    }
    
    // Update app context if the session is activated and update UI with the command status.
    //
    public func updateAppContext(_ context: [String: Any]) {
        guard WCSession.default.activationState == .activated else {
            debugPrint("WCSession is not activated yet!")
            return
        }
        do {
            try WCSession.default.updateApplicationContext(context)
            logger.debug("context sent")
        } catch {
            debugPrint(error)
        }
    }

    // Send a message if the session is activated and update UI with the command status.
    //
    public func sendMessage(_ message: [String: Any]) {
        guard WCSession.default.activationState == .activated,
              WCSession.default.isReachable else {
            debugPrint("WCSession is not reachable")
            return
        }

        #if os(watchOS)
        logger.debug("message sent from watch")
        #else
        logger.debug("message sent from iOS")
        #endif

        WCSession.default.sendMessage(message, replyHandler: nil) { error in
            debugPrint(error)
        }        
    }

    public func sendMessage(_ message: [String: Any],
                     replyHandler: @escaping ([String: Any]) -> Void) {
        guard WCSession.default.activationState == .activated,
              WCSession.default.isReachable else {
            debugPrint("WCSession is not activated yet!")
            return
        }

        #if os(watchOS)
        logger.debug("message sent from watch")
        #else
        logger.debug("message sent from iOS")
        #endif

        WCSession.default.sendMessage(message, replyHandler: replyHandler) { error in
            debugPrint(error)
        }
    }

    // Transfer a piece fo user info for current complications if the session is activated
    // and update UI with the command status.
    // a WCSessionUserInfoTransfer object is returned to monitor the progress or cancel the operation.
    //
    public func transferCurrentComplicationUserInfo(_ userInfo: [String: Any]) {
        guard WCSession.default.activationState == .activated else {
            debugPrint("WCSession is not activated yet!")
            return
        }

        #if os(iOS)
        if WCSession.default.isComplicationEnabled {
            let userInfoTranser = WCSession.default.transferCurrentComplicationUserInfo(userInfo)
            logger.debug("complication transfer remaining:  \(WCSession.default.remainingComplicationUserInfoTransfers)")
            logger.debug("\(userInfoTranser.isTransferring)")
            lastComplicationSentDate = Date()
        } else {
            debugPrint("Complication is not enabled!")
        }
        #endif
    }

    func setComplicationSubscriber() {
        cancellable = complicationPublisher
            .debounce(for: .seconds(5 * 60), scheduler: RunLoop.current)
            .sink { [weak self] userInfo in
                self?.logger.debug("throtled complication sent \(userInfo)")
                self?.queuedComplication = nil
                WatchSender.shared.transferCurrentComplicationUserInfo(userInfo)
            }
    }

    public func sendQueuedComplication() {
        guard let userInfo = queuedComplication else { return }
        WatchSender.shared.transferCurrentComplicationUserInfo(userInfo)
        logger.debug("queued complication sent")
    }
}
