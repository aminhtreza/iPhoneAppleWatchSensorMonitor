//
//  mainWatchIFC.swift
//  continousHeartRateMonitor WatchKit Extension
//
//  Created by iMac on 3/9/20.
//  Copyright © 2020 Amin Hamiditabar. All rights reserved.
//

import SwiftUI

struct mainWatchIFC: View {
    
    //Hear rate
    @ObservedObject var HeartRateManager = heartRateManager()
    @State var workoutOn: Bool = false
    var workout = false
    @State var collectionStatus: String = "Start collecting"
    
    //Motion
    @ObservedObject var motionManager = MotionManager()
    
    var body: some View {
        ScrollView{
            VStack{
                    VStack {
                        VStack{
                            Button(
                                    action: {
                                    self.workoutOn.toggle()
                                        if self.workoutOn {
                                            self.HeartRateManager.startWorkout()
                                            self.collectionStatus = "Stop collecting"
                                        } else {
                                            print("Heart rate was last seen as: \(self.HeartRateManager.updatedHRValue)")
                                            self.HeartRateManager.stopWorkout()
                                            self.collectionStatus = "Start collecting"
                                        }
                                    }) {
                                    Text("\(collectionStatus)")
                                }
                                Text("HeartRate bpm: \(HeartRateManager.updatedHRValue)")
                            }
                        HStack{
                            Text("Motion ")
                            VStack {
                                Text("   Roll: \(motionManager.Roll)")
                                Text("   Yaw: \(motionManager.Yaw)")
                                Text("   Pitch: \(motionManager.Pitch)")
                            }
                        }
                    
                    }
                    HStack {
                        Text("Location")
                        VStack{
                            Text("Latitude: \(motionManager.latitude)")
                            Text("Longitude: \(motionManager.longitude)")
                            Text("Altitude: \(motionManager.altitude)")
                        }
                        
                    }
                }
                .onAppear(perform: AuthorizationManager.AuthorizeHK)
                .onAppear(perform: motionManager.startQueuedMotionUpdates)
                .onAppear(perform: motionManager.setupLocation)
            }
        }
}

struct mainWatchIFC_Previews: PreviewProvider {
    static var previews: some View {
        mainWatchIFC()
    }
}
