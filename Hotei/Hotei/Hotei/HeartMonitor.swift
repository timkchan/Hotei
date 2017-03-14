//
//  HeartMonitor.swift
//  Hotei
//
//  Created by Ryan Dowse on 11/03/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import Foundation
import CoreBluetooth
import NotificationCenter

/*
 source: https://github.com/jayliew/bluetoothPolarH7Swift/blob/master/bluetoothPolarH7/ViewController.swift#L10
 */

class HeartMonitor: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    // Central manager and peripheral for bluetooth device
    var centralManager:CBCentralManager!
    var connectingPeripheral:CBPeripheral!
    
    // Device UUID info
    let POLARH7_HRM_HEART_RATE_SERVICE_UUID = "180D"
    let POLARH7_HRM_DEVICE_INFO_SERVICE_UUID = "180A"
    
    // Buffer storing current RR intervals within a set time frame
    var rrIntervalBuffer = Array(repeating:0.0,count:10000) // Estimated the memory space required
    var rrIntervalBufferIndex = 0 // Keep track of latest new sample
    
    // Buffer storing all of the current HR sample
    var hrBuffer = Array(repeating:0.0,count:10000) // Estimated the memory space required
    var hrBufferIndex = 0 // Keep track of latest new sample
    
    // Time between feature calculations, in seconds
    let updateCalcInterval = 60.0
    
    // Current states for the user
    var sdnn = 0.0 // HRV value
    var hr = 0
    var mean_hr = 0.0;
    
    // Flags for reading heartrate characteristics data
    struct hrflags{
        // Flags
        var _hr_format_bit:UInt8 // bits 1
        var _sensor_contact_bit:UInt8 // bits 2
        var _energy_expended_bit:UInt8 // bits 1
        var _rr_interval_bit:UInt8 // bits 1
        
        // Read flags from byte.
        init(flag: UInt8) {
            _hr_format_bit = flag & 0x1
            _sensor_contact_bit = (flag >> 1) & 0x3
            _energy_expended_bit = (flag >> 3) & 0x1
            _rr_interval_bit = (flag >> 4) & 0x1
        }
        
        // Return if HR is 8 or 16 bit
        func getHRSize() -> Int {
            return Int(_hr_format_bit) + 1
        }
    }
    
    // Mark: update calculations for features
    
    func updateCalc(){
        /*
         *   Features to calc:
         *   eg. HRV, Mean HR.
         */
        calcHRV()
        calcMeanHR()
        
        // Notify that the feature calculations have been updated
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshFeatures"), object: nil)
    }
    
    func calcHRV(){
        // calculate MRR
        var rrTotal = 0.0
        for i in 0...rrIntervalBufferIndex{
            rrTotal += rrIntervalBuffer[i]
        }
        let mrr = rrTotal/Double(rrIntervalBufferIndex)
        
        // calculate SDNN
        var sdnnTotal = 0.0
        for i in 0...rrIntervalBufferIndex{
            sdnnTotal+=pow(rrIntervalBuffer[i]-mrr,2)
        }
        sdnn = sqrt(sdnnTotal/Double(rrIntervalBufferIndex))
        
        // Refill buffer
        rrIntervalBufferIndex=0
    }
    
    func calcMeanHR(){
        var hrTotal = 0.0
        for i in 0...hrBufferIndex{
            hrTotal += hrBuffer[i]
        }
        mean_hr = hrTotal/Double(hrBufferIndex)
        hrBufferIndex = 0
    }
    
    // Mark: getter functions
    
    func getHRV()-> Double{
        return self.sdnn
    }
    
    func getMeanHR()->Double{
        return self.mean_hr
    }
    
    func getHR() -> Int{
        return self.hr
    }
    
    // Run function to connect to the device.
    func scanForDevices(){
        // Services to search
        let heartRateServiceUUID = CBUUID(string: POLARH7_HRM_HEART_RATE_SERVICE_UUID)
        let deviceInfoServiceUUID = CBUUID(string: POLARH7_HRM_DEVICE_INFO_SERVICE_UUID)
        let services = [heartRateServiceUUID, deviceInfoServiceUUID];
        
        // CBCentralManager init
        let centralManager = CBCentralManager(delegate: self, queue: nil)
        centralManager.scanForPeripherals(withServices: services, options: nil)
        self.centralManager = centralManager;
    }
    
    /*
     *   Mark -- Bluetooth code
     */
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("--- centralManagerDidUpdateState")
        switch central.state{
        case .poweredOn:
            print("poweredOn")
            
            let serviceUUIDs:[AnyObject] = [CBUUID(string: "180D")]
            let lastPeripherals = centralManager.retrieveConnectedPeripherals(withServices: serviceUUIDs as! [CBUUID])
            
            if lastPeripherals.count > 0{
                let device = lastPeripherals.last! as CBPeripheral;
                connectingPeripheral = device;
                centralManager.connect(connectingPeripheral, options: nil)
            }
            else {
                centralManager.scanForPeripherals(withServices: serviceUUIDs as? [CBUUID], options: nil)
            }
        case .poweredOff:
            print("--- central state is powered off")
        case .resetting:
            print("--- central state is resetting")
        case .unauthorized:
            print("--- central state is unauthorized")
        case .unknown:
            print("--- central state is unknown")
        case .unsupported:
            print("--- central state is unsupported")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("--- didDiscover peripheral")
        
        if let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            print("--- found heart rate monitor named \(localName)")
            self.centralManager.stopScan()
            connectingPeripheral = peripheral
            connectingPeripheral.delegate = self
            centralManager.connect(connectingPeripheral, options: nil)
        }else{
            print("!!!--- can't unwrap advertisementData[CBAdvertisementDataLocalNameKey]")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("--- didConnectPeripheral")
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        print("--- peripheral state is \(peripheral.state)")
        
        /* TIMERS
         * set timer for the frequency of feature calculations, eg. HRV
         */
        let date = Date().addingTimeInterval(self.updateCalcInterval)
        let timer = Timer(fireAt: date, interval: self.updateCalcInterval, target: self, selector:  #selector(updateCalc), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("--- Peripheral error")
        if (error) != nil{
            print("!!!--- error in didDiscoverServices: \(error?.localizedDescription)")
        }
        else {
            print("--- error in didDiscoverServices")
            for service in peripheral.services as [CBService]!{
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("--- Peripheral call")
        if (error) != nil{
            print("!!!--- error in didDiscoverCharacteristicsFor: \(error?.localizedDescription)")
        }
        else {
            
            if service.uuid == CBUUID(string: "180D"){
                for characteristic in service.characteristics! as [CBCharacteristic]{
                    switch characteristic.uuid.uuidString{
                        
                    case "2A37":
                        // Set notification on heart rate measurement
                        print("Found a Heart Rate Measurement Characteristic")
                        peripheral.setNotifyValue(true, for: characteristic)
                        
                    case "2A38":
                        // Read body sensor location
                        print("Found a Body Sensor Location Characteristic")
                        peripheral.readValue(for: characteristic)
                        
                    case "2A29":
                        // Read body sensor location
                        print("Found a HRM manufacturer name Characteristic")
                        peripheral.readValue(for: characteristic)
                        
                    case "2A39":
                        // Write heart rate control point
                        print("Found a Heart Rate Control Point Characteristic")
                        
                        var rawArray:[UInt8] = [0x01];
                        let data = NSData(bytes: &rawArray, length: rawArray.count)
                        peripheral.writeValue(data as Data, for: characteristic, type: CBCharacteristicWriteType.withoutResponse)
                        
                    default:
                        print()
                    }
                    
                }
            }
        }
    }
    
    func getUInt16Format(data:[UInt8],offset:Int) -> UInt16{
        let higher_bits:UInt32 = UInt32(data[offset+1])
        let lower_bits:UInt32 = UInt32(data[offset])
        return UInt16(higher_bits<<8 + lower_bits)
    }
    
    func update(heartRateData:Data){
        /*
         https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.characteristic.heart_rate_measurement.xml
         Information for reading heart rate measurement characteristic data.
        */
        
        print("--- UPDATING ..")
        // Copy data into buffer
        var buffer = [UInt8](repeating: 0x00, count: heartRateData.count)
        heartRateData.copyBytes(to: &buffer, count: buffer.count)
        
        // Read
        let flags:UInt8 = buffer[0]
        let heartRateFlags = hrflags(flag: flags)
        
        var offset:Int = 1 // track current byte
        var bpm:UInt16?
        
        // Read heart rate
        if(heartRateFlags._hr_format_bit==1){ // 16bit format
            bpm = getUInt16Format(data: buffer, offset: offset)
            print("--- BPM: \(bpm)")
            // save current heart rate
            self.hr = Int(bpm!)
            offset+=2
        } else { // 8bit format
            bpm = UInt16(buffer[offset]);
            print("--- BPM: \(bpm)")
            self.hr = Int(bpm!)
            
            offset+=1
        }
        
        // Store latest hr sample
        if(hrBufferIndex < hrBuffer.count){
            hrBuffer[hrBufferIndex] = Double(self.hr)
            hrBufferIndex += 1
        } else {
            print("Error: hrBuffer index exceeded")
        }
        
        // Read devices current energy level
        if(heartRateFlags._energy_expended_bit==1){
            // process energy value if needed
            offset+=2
        }
        
        var rr_interval:Double?
        if(heartRateFlags._rr_interval_bit==1 && offset < buffer.count){ // resolution 1/1024 second
            let rr_value:UInt16 = getUInt16Format(data: buffer, offset: offset)
            rr_interval = (Double(rr_value)/1024.0) * 1000.0
            print("--- rr: \(rr_interval)")
            offset+=2
            print("--- hrv: \(sdnn)")
            
            // Store rr intervals
            if(rrIntervalBufferIndex < rrIntervalBuffer.count){
                rrIntervalBuffer[rrIntervalBufferIndex] = rr_interval!
                rrIntervalBufferIndex += 1
            } else {
                print("Error: rrIntervalBuffer index exceeded")
            }
        }
        
        // Notify that the HR value has been updated
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)
    }
    
    // called on every update of the peripheral
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("--- didUpdateValueForCharacteristic")
        
        if (error) != nil{
            
        }else {
            switch characteristic.uuid.uuidString{
            case "2A37":
                update(heartRateData:characteristic.value!)
            default:
                print("--- something other than 2A37 uuid characteristic")
            }
        }
    }
    
}
