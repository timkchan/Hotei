//
//  InterfaceController.swift
//  HoteiW Extension
//
//  Created by Tim Kit Chan on 28/02/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion
import WatchConnectivity
import CoreLocation

class InterfaceController: WKInterfaceController, WCSessionDelegate, CLLocationManagerDelegate {
    
    var count = 0

    @IBAction func sendData() {
        print("yes")
        count += 1
        stepCount.setText("100")
        if(WCSession.isSupported()){
            session.sendMessage(["count" : "\(count)"], replyHandler: nil, errorHandler: nil)
        }
    }
    
    @IBOutlet var labelX: WKInterfaceLabel!
    
    @IBOutlet var labelY: WKInterfaceLabel!
    
    @IBOutlet var labelZ: WKInterfaceLabel!
    
    @IBOutlet var stepCount: WKInterfaceLabel!
    
    let motionManager = CMMotionManager()
    let corePedometer = CMPedometer()
    let activityManager = CMMotionActivityManager()
    let locationManager = CLLocationManager()
    let startDate = Date()
    
    
    
    var session: WCSession!
    
    
    
//    func initWCSession(){
//        session.delegate = self
//        session.activate()
//    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        motionManager.accelerometerUpdateInterval = 1
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        
        // This method is called when watch view controller is about to be visible to user
 
        
        super.willActivate()
        
        if(WCSession.isSupported()){
            self.session = WCSession.default()
            self.session.delegate = self
            self.session.activate()
        }
        
        locationManager.requestAlwaysAuthorization()
        
        if(CMMotionActivityManager.isActivityAvailable()){
            self.activityManager.startActivityUpdates(to: OperationQueue.main, withHandler: {(data: CMMotionActivity!) -> Void in
                
                if(data.stationary){
                    self.stepCount.setText("Stationary")
                }
                else if(data.walking){
                    self.stepCount.setText("Walking")
                }
                else if(data.running){
                    self.stepCount.setText("Running")
                }
                
                
            } as! CMMotionActivityHandler)
        }
        
        
//        if(CMPedometer.isPaceAvailable()){
//            
//            corePedometer.startUpdates(from: startDate, withHandler: {(data:CMPedometerData?, error: Error?) -> Void in
//                
//                if(error == nil){
//                    self.stepCount.setText("\(data!.numberOfSteps)")
//                }
//
//            } )
//        }
        
        
        
        if(motionManager.isAccelerometerAvailable){
            let handler:CMAccelerometerHandler = {(data: CMAccelerometerData?, error: Error?) -> Void in
                
                self.labelX.setText(String(format: "%.2f", data!.acceleration.x))
                self.labelY.setText(String(format: "%.2f", data!.acceleration.y))
                self.labelZ.setText(String(format: "%.2f", data!.acceleration.z))
            }
            
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: handler)
            
//            motionManager.startAccelerometerUpdates(to: OperationQueue.current!){ (data, error) in
//                
//                if let myData = data{
//                    //print(myData)
//                }
//                
//            }
        }
        else{
            self.labelX.setText("not available")
            self.labelY.setText("not available")
            self.labelZ.setText("not available")
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        //motionManager.stopAccelerometerUpdates()
        
    }

}
