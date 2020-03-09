//
//  workoutCreator.swift
//  continousHeartRateMonitor WatchKit Extension
//
//  Created by iMac on 2/18/20.
//  Copyright © 2020 Amin Hamiditabar. All rights reserved.
//

import Foundation
import HealthKit

class workoutCreator {
    
    let healthStore = HKHealthStore()
    let heartRateQuantity = HKUnit(from: "count/min")
    var HeartRate: heartRate = heartRate(bpm: 0.0)
    
    
}
