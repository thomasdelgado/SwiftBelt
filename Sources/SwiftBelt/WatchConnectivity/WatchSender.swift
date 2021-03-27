//
//  WatchSender.swift
//  Watch Extension
//
//  Created by Thomas Delgado on 24/03/21.
//  Copyright © 2021 Thomas Delgado. All rights reserved.
//

import Foundation
import WatchConnectivity

public class WatchSender {
    public static let shared = WatchSender()
    public var isAbleToSendMessages: Bool {
        WCSession.default.activationState == .activated && WCSession.default.isReachable
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
            debugPrint(userInfoTranser.isTransferring)
        } else {
            debugPrint("Complication is not enabled!")
        }
        #endif
    }
}
