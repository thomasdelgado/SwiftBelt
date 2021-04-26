//
//  SessionDelegate.swift
//  Watch Extension
//
//  Created by Thomas Delgado on 24/03/21.
//  Copyright © 2021 Thomas Delgado. All rights reserved.
//

import WatchConnectivity
import Combine
#if os(watchOS)
import ClockKit
#endif
import os

public protocol WatchSessionMessageDelegate {
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void)
}

public class WatchSessionDelegate: NSObject, WCSessionDelegate {
    let logger = Logger(subsystem: "com.delgado.swiftbelt", category: "Watch Delegate")
    
    public static let shared = WatchSessionDelegate()
    public let sessionPublisher = PassthroughSubject<WatchSessionEvent, Never>()
    public var delegate: WatchSessionMessageDelegate?
    public var session: WCSession {
        return WCSession.default
    }

    public func activate() {
        if WCSession.isSupported() && WCSession.default.activationState != .activated {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        #if os(watchOS)
        debugPrint("watch session active")
        #else
        debugPrint("iOS session active")
        #endif
        sessionPublisher.send(.sessionStarted)
    }

    // Called when an app context is received.
    //
    public func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        logger.debug("\(#function) received context \(applicationContext)")
//        logger.debug("\(#function) received context")
        sessionPublisher.send(.messageReceived(message: applicationContext))
    }

    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        sessionPublisher.send(.messageReceived(message: message))
    }

    public func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        delegate?.session(session, didReceiveMessage: message, replyHandler: replyHandler)
    }

    // Called when a userInfo is received.
    // This method is shared with sending transferUserInfo, so it might need a key to differenciate
    //
    public func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        #if os(watchOS)
        let server = CLKComplicationServer.sharedInstance()
        if let complications = server.activeComplications {
            for complication in complications {
                // Call this method sparingly. If your existing complication data is still valid,
                // consider calling the extendTimeline(for:) method instead.
                server.reloadTimeline(for: complication)
            }
        }
        #endif
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
        if session.activationState == .activated {
            //if state changes and activation state is active, it's a nice opportunity to update app context
            sessionPublisher.send(.stateChanged)
        }
    }
    #endif

    // Called when WCSession reachability is changed.
    //
    public func sessionReachabilityDidChange(_ session: WCSession) {
        debugPrint("\(#function): isReachable = \(session.isReachable)")
    }
}

public enum WatchSessionEvent {
    case sessionStarted
    case stateChanged
    case messageReceived(message: [String: Any])
}

extension WatchSessionDelegate {
    public func activateAndReload() {
        if session.activationState == .activated {
            sessionPublisher.send(.sessionStarted)
        } else {
            activate()
        }
    }
}
