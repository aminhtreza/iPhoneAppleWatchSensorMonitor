//
//  InterfaceController.swift
//  continousHeartRateMonitor WatchKit Extension
//
//  Created by iMac on 2/18/20.
//  Copyright © 2020 Amin Hamiditabar. All rights reserved.
//

import Foundation
import HealthKit

class heartRateManager: NSObject, ObservableObject, HKLiveWorkoutBuilderDelegate, HKWorkoutSessionDelegate {
    
    var session: HKWorkoutSession!
    var builder: HKLiveWorkoutBuilder!
    let healthStore = HKHealthStore()
    
    // https://www.appsdissected.com/swiftui-updates-main-thread-debug-crash/
    @Published var updatedHRValue: String = "--"
    
    func startWorkout() {
        initWorkout() // Initialize our workout
        session.startActivity(with: Date()) // Start the workout session and begin data collection
        builder.beginCollection(withStart: Date()) { (succ, error) in
            if !succ {
                fatalError("Error beginning collection from builder: \(String(describing: error)))")
            }
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (Timer) in
            self.updatedHRValue = self.HR
            sensorData["HR"] = self.HR
        }
    }
    
    func initWorkout() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .running
        configuration.locationType = .outdoor
        
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session.associatedWorkoutBuilder()
        } catch {
            fatalError("Unable to create the workout session!")
        }
        
        // Setup session and builder.
        session.delegate = self //as? HKWorkoutSessionDelegate
        builder.delegate = self //as? HKLiveWorkoutBuilderDelegate
        
        // Set the workout builder's data source.
        builder.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore,
                                                     workoutConfiguration: configuration)
        print("Workout initialized")
    }
    
    func stopWorkout() {
        // Stop the workout session
        session.end()
        builder.endCollection(withEnd: Date()) { (success, error) in
            self.builder.finishWorkout { (workout, error) in
                DispatchQueue.main.async() {
                    self.session = nil
                    self.builder = nil
                }
            }
        }
        self.HR = "--"
        print("workout ended")
    }
    
    var HR: String = "--"
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        print("entered workoutbuilder")
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else {
                return
            }
            switch quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let statistics = workoutBuilder.statistics(for: quantityType)
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                let value = statistics!.mostRecentQuantity()?.doubleValue(for: heartRateUnit)
                HR = String(Int(Double(round(1 * value!) / 1)))
                print("[workoutBuilder] Heart Rate: \(HR)")
            default:
                return
            }
        }
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        // Retreive the workout event.
        guard let workoutEventType = workoutBuilder.workoutEvents.last?.type else { return }
        print("[workoutBuilderDidCollectEvent] Workout Builder changed event: \(workoutEventType.rawValue)")
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print("[workoutSession] Changed State: \(toState.rawValue)")
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("[workoutSession] Encountered an error: \(error)")
    }
    
}
