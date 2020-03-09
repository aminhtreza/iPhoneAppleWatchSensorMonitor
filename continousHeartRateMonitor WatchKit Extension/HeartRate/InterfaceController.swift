//
//  InterfaceController.swift
//  continousHeartRateMonitor WatchKit Extension
//
//  Created by iMac on 2/18/20.
//  Copyright © 2020 Amin Hamiditabar. All rights reserved.
//

import SwiftUI
import HealthKit

let AuthorizationManager = authorizationManager()
struct InterfaceController: View {
    @State var workoutOn: Bool = false
    var workout = false
    @State var workoutState: String = "Start workout"
    @State var bpm: String = "--"
    
    @ObservedObject var HeartRateManager = heartRateManager()
    
    var body: some View {
        VStack {
            VStack {
                VStack {
                    Button(
                        action: {
                        self.workoutOn.toggle()
                            if self.workoutOn {
                                self.HeartRateManager.startWorkout()
                                self.workoutState = "Stop workout"
                            } else {
                                print("Heart rate was last seen as: \(self.HeartRateManager.updatedHRValue)")
                                self.HeartRateManager.stopWorkout()
                                self.workoutState = "Start workout"
                            }
                        }) {
                        Text("\(workoutState)")
                    }
                }
                Text("\(HeartRateManager.updatedHRValue)")
            }
            .onAppear(perform: AuthorizationManager.AuthorizeHK)
        }
    }
    
    let healthStore = HKHealthStore()
    let heartRateQuantity = HKUnit(from: "count/min")
    //var HeartRate: heartRate = heartRate(bpm: 0.0)
}

struct InterfaceController_Previews: PreviewProvider {
    static var previews: some View {
        InterfaceController()
    }
}


