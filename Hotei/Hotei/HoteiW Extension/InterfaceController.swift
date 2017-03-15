//
//  InterfaceController.swift
//  HoteiW Extension
//
//  Created by Tim Kit Chan on 28/02/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import CoreMotion
import CoreLocation


class InterfaceController: WKInterfaceController, WCSessionDelegate, CLLocationManagerDelegate {
    
    var session : WCSession!
    
    @IBOutlet var debugLabel: WKInterfaceLabel!
    @IBOutlet var currentActivityLabel: WKInterfaceLabel!
    
    let activityManager = CMMotionActivityManager()
    let locationManager = CLLocationManager()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        
        if (WCSession.isSupported()) {
            self.session = WCSession.default()
            self.session.delegate = self
            self.session.activate()
        }
        
        locationManager.requestAlwaysAuthorization()
        if(CMMotionActivityManager.isActivityAvailable()){
            self.activityManager.startActivityUpdates(to: OperationQueue.main) {
                data in
                DispatchQueue.main.async {
                    if (data?.running)! {
                        self.currentActivityLabel.setText("Running")
                    } else if (data?.cycling)! {
                        self.currentActivityLabel.setText("Cycling")
                    } else if (data?.walking)! {
                        self.currentActivityLabel.setText("Walking")
                    } else if (data?.stationary)! {
                        self.currentActivityLabel.setText("Lazy")
                    } else {
                        self.currentActivityLabel.setText("Nill")
                    }
                }
            }
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        let value = message["isExercising"] as? String
        //use this to present immediately on the screen
        DispatchQueue.main.async {
            self.debugLabel.setText(value)
        }
    }
    

}
