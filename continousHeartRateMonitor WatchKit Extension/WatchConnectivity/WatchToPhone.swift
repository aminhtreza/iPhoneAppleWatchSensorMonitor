//
//  WatchToPhone.swift
//  continousHeartRateMonitor WatchKit Extension
//
//  Created by iMac on 3/9/20.
//  Copyright © 2020 Amin Hamiditabar. All rights reserved.
//

import Foundation
import WatchConnectivity


class WatchtoPhone: NSObject, WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
    }
    
    func activateSession() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            print("Watch session activated")
        } else {
            print("WC session not supported)")
        }
    }
    
    var lastMessage: CFAbsoluteTime = 0
    func sendPhoneMessage(message: Dictionary<String, String>) {
        let currentTime = CFAbsoluteTimeGetCurrent()
            if lastMessage + 0.5 > currentTime {
                return
            }
        if (WCSession.default.isReachable) {
            WCSession.default.sendMessage(message as [String : Any], replyHandler: nil)
        }
        lastMessage = CFAbsoluteTimeGetCurrent()
    }
}
