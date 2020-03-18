//
//  MotionManager.swift
//  continousHeartRateMonitor WatchKit Extension
//
//  Created by iMac on 3/9/20.
//  Copyright © 2020 Amin Hamiditabar. All rights reserved.
//

import Foundation
import CoreLocation
import CoreMotion
import WatchConnectivity

var watchToPhone = WatchtoPhone()


// Hey Ryan
// Hey Amin
class MotionManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var motionManager = CMMotionManager()
    var locationManager = CLLocationManager()
    let date = NSTimeIntervalSince1970
        
    @Published var Roll: String = "--"
    @Published var Yaw: String = "--"
    @Published var Pitch: String = "--"
    
    @Published var latitude: String = "--"
    @Published var longitude: String = "--"
    @Published var altitude: String = "--"
    
    func setupLocation() {
        print("cool")
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 1
    }
    
    func startQueuedMotionUpdates() {
       if motionManager.isDeviceMotionAvailable {
        self.motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
        self.motionManager.showsDeviceMovementDisplay = true
        // if watch 5 or later: (using: .xMagneticNorthZVertical, ...
        self.motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: OperationQueue.current!, withHandler: { (data, error) in
            
             if let validData = data {
                // Get the attitude relative to the magnetic north reference frame.
                print("We got here")
                let roll = validData.attitude.roll
                let pitch = validData.attitude.pitch
                let yaw = validData.attitude.yaw
                print("roll :\(roll), pitch: \(pitch), yaw: \(yaw)")
                
                self.Roll = String(Double(roll).rounded(toPlaces: 2))
                self.Pitch = String(Double(pitch).rounded(toPlaces: 2))
                self.Yaw = String(Double(yaw).rounded(toPlaces: 2))

                sensorData["roll"] = self.Roll
                sensorData["yaw"] = self.Yaw
                sensorData["pitch"] = self.Pitch
             }
                     
          })
       }
       else {
        fatalError("App doesn't have device motion available")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // makes sure nothing went wrong and we have location data
        // locations are put into an array, so we grab the first piece of data
        // let lastLocation = locations.last!
        if let location = locations.last {
    
            // process measurment, save it as a dictionary, and send it to the phone
            self.latitude = "\(round(location.coordinate.latitude * 1000) / 1000)"
            self.longitude = "\(round(location.coordinate.longitude * 1000) / 1000)"
            self.altitude = "\(round(location.altitude * 1000) / 1000)"
            
            // print("location changed: \(round(location.coordinate.latitude * 1000) / 1000), \(round(location.coordinate.longitude * 1000) / 1000), \(round(location.altitude * 1000) / 1000),Date: \(self.date)")
            sensorData["altitude"] = self.altitude
            sensorData["longitude"] = self.longitude
            sensorData["latitude"] = self.latitude

        }
    }
}

extension Double {
    // rounds doubles to a decimal
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


