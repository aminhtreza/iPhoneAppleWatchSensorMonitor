//
//  MotionIFC.swift
//  continousHeartRateMonitor WatchKit Extension
//
//  Created by iMac on 3/9/20.
//  Copyright © 2020 Amin Hamiditabar. All rights reserved.
//

import SwiftUI

struct MotionIFC: View {
    @ObservedObject var motionManager = MotionManager()
    
    var body: some View {
        VStack{
            Text("Roll: \(motionManager.Roll)")
            Text("Yaw: \(motionManager.Yaw)")
            Text("Pitch: \(motionManager.Pitch)")
            VStack {
                Text("Latitude: \(motionManager.latitude)")
                Text("Longitude: \(motionManager.longitude)")
                Text("Altitude: \(motionManager.altitude)")
            }
            
        }
        .onAppear(perform: motionManager.startQueuedMotionUpdates)
        .onAppear(perform: motionManager.setupLocation)
    }
}

struct MotionIFC_Previews: PreviewProvider {
    static var previews: some View {
        MotionIFC()
    }
}
