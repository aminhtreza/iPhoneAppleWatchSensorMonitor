//
//  AuthorizationManager.swift
//  continousHeartRateMonitor WatchKit Extension
//
//  Created by iMac on 2/18/20.
//  Copyright © 2020 Amin Hamiditabar. All rights reserved.
//

import Foundation
import HealthKit

class authorizationManager {
    var authorized: Bool = false
    let healthStore = HKHealthStore()
    
    func AuthorizeHK() {
        if HKHealthStore.isHealthDataAvailable() {
            //let heartRateQuantityType = HKObjectType.quantityType(forIdentifier: .heartRate)!
            let typesToShare: Set = [HKQuantityType.workoutType()]
            let typesToRead: Set = [HKQuantityType.quantityType(forIdentifier: .heartRate)!]
            healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (succ, error) in
                if !succ {
                    fatalError("Error requesting authorization from health store: \(String(describing: error)))")
                }
            }
            authorized = true
            print("Authorized")
        } else {
            fatalError("Healthkit is not available for device")
        }
    }
}

