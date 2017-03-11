//
//  WatchSessionManager.swift
//  Hotei
//
//  Created by Akshay  on 11/03/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import WatchConnectivity


class WatchSessionManager: NSObject, WCSessionDelegate{
    
    static let sharedManager = WatchSessionManager()
    private override init() {
        super.init()
    }
    
    private let session = WCSession.default()
    
    func startSession(){
        session.delegate = self
        session.activate()
    }
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
    
    
    
    
    
    
    
}
