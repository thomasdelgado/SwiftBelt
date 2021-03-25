//
//  SessionDelegate.swift
//  Watch Extension
//
//  Created by Thomas Delgado on 24/03/21.
//  Copyright © 2021 Thomas Delgado. All rights reserved.
//

import WatchConnectivity
import Combine

public class WatchSessionDelegate: NSObject, WCSessionDelegate {
    public static let shared = WatchSessionDelegate()
    public let sessionPublisher = PassthroughSubject<[String: Any], Never>()

    public func activate() {
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //what to do here?
        #if os(watchOS)
        debugPrint("watch session active")
        #else
        debugPrint("iOS session active")
        #endif
        debugPrint(session)
        debugPrint(activationState.rawValue)
        debugPrint(error as Any)
    }

    // Called when an app context is received.
    //
    public func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        sessionPublisher.send(applicationContext)
    }

    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        sessionPublisher.send(message)
    }

    public func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        sessionPublisher.send(message)
        replyHandler([:])
    }

}

extension WatchSessionDelegate {
    // WCSessionDelegate methods for iOS only.
    //
    #if os(iOS)
    public func sessionDidBecomeInactive(_ session: WCSession) {
        debugPrint("\(#function): activationState = \(session.activationState.rawValue)")
    }

    public func sessionDidDeactivate(_ session: WCSession) {
        // Activate the new session after having switched to a new watch.
        session.activate()
    }

    public func sessionWatchStateDidChange(_ session: WCSession) {
        debugPrint("\(#function): activationState = \(session.activationState.rawValue)")
    }
    #endif

//    // Called when WCSession activation state is changed.
//    //
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//        postNotificationOnMainQueueAsync(name: .activationDidComplete)
//    }
//
//    // Called when WCSession reachability is changed.
//    //
//    func sessionReachabilityDidChange(_ session: WCSession) {
//        postNotificationOnMainQueueAsync(name: .reachabilityDidChange)
//    }

}
