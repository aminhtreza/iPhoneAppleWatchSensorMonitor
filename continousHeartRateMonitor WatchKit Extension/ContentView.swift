//
//  ContentView.swift
//  continousHeartRateMonitor WatchKit Extension
//
//  Created by iMac on 2/18/20.
//  Copyright © 2020 Amin Hamiditabar. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        mainWatchIFC()
            .onAppear(perform: watchToPhone.activateSession)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
