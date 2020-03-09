//
//  MotionManager.swift
//  continousHeartRateMonitor
//
//  Created by iMac on 3/9/20.
//  Copyright © 2020 Amin Hamiditabar. All rights reserved.
//

import Foundation
import CoreLocation
import CoreMotion

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
        locationManager.distanceFilter = 0.25
    }
    
    func startQueuedMotionUpdates() {
       if motionManager.isDeviceMotionAvailable {
        self.motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
        self.motionManager.showsDeviceMovementDisplay = true
        self.motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: OperationQueue.current!, withHandler: { (data, error) in
             // Make sure the data is valid before accessing it.
             if let validData = data {
                // Get the attitude relative to the magnetic north reference frame.
                let roll = validData.attitude.roll
                let pitch = validData.attitude.pitch
                let yaw = validData.attitude.yaw
                
                self.Roll = String(Double(roll).rounded(toPlaces: 2))
                self.Pitch = String(Double(pitch).rounded(toPlaces: 2))
                self.Yaw = String(Double(yaw).rounded(toPlaces: 2))
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
    
            // prints to the app and round it to three decimal places
            self.latitude = "\(round(location.coordinate.latitude * 1000) / 1000)"
            self.longitude = "\(round(location.coordinate.longitude * 1000) / 1000)"
            self.altitude = "\(round(location.altitude * 1000) / 1000)"
            print("location changed: \(round(location.coordinate.latitude * 1000) / 1000), \(round(location.coordinate.longitude * 1000) / 1000), \(round(location.altitude * 1000) / 1000),Date: \(self.date)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            print("status is authorized")
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                }
            }
        }
        if status == .authorizedWhenInUse || status == .denied {
            locationManager.requestAlwaysAuthorization()
            print("Status changed")
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
