//
//  coreMotion.swift
//  continousHeartRateMonitor WatchKit Extension
//
//  Created by iMac on 2/25/20.
//  Copyright © 2020 Amin Hamiditabar. All rights reserved.
//

import Foundation
import CoreMotion

var motionManager: CMMotionManager!

class MotionManager {
    var motionManager = CMMotionManager()
    
    func startMotionManager() {
        self.motionManager.startAccelerometerUpdates()
    }
}
