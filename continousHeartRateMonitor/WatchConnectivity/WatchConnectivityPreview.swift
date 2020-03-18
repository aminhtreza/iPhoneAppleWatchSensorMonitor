//
//  WatchConnectivityPreview.swift
//  continousHeartRateMonitor
//
//  Created by iMac on 3/9/20.
//  Copyright © 2020 Amin Hamiditabar. All rights reserved.

import SwiftUI
struct WatchConnectivityPreview: View {
    @ObservedObject var phonetoWatch = PhonetoWatch()
    
    var body: some View {
        VStack {
            Button(action: {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (Timer) in
                    self.phonetoWatch.updateUI()
                }
            }) {
                Text("Tap to start updating")
            }
            VStack {
                VStack{
                    Text("Watch latitude: \(phonetoWatch.watchLatitude)")
                    Text("Watch longitude: \(phonetoWatch.watchLongitude)")
                    Text("Watch altitude: \(phonetoWatch.watchAltitude)")
                    Text("Watch Roll: \(phonetoWatch.watchRoll)")
                    Text("Watch Pitch: \(phonetoWatch.watchPitch)")
                    Text("Watch Yaw: \(phonetoWatch.watchYaw)")
                    Text("Watch Heart rate: \(phonetoWatch.HeartRate)")
                }
                .onAppear(perform: phonetoWatch.activateSession)
            }
        }
    }
}

struct WatchConnectivityPreview_Previews: PreviewProvider {
    static var previews: some View {
        WatchConnectivityPreview()
    }
}
