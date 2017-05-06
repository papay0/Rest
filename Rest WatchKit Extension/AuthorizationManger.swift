//
//  AuthorizationManger.swift
//  Rest
//
//  Created by Arthur Papailhau on 5/6/17.
//  Copyright © 2017 Arthur Papailhau. All rights reserved.
//

import HealthKit

class AuthorizationManager {

    static func requestAuthorization(completionHandler: @escaping ((_ success: Bool) -> Void)) {
        // Create health store.
        let healthStore = HKHealthStore()

        // Check if there is health data available.
        if !HKHealthStore.isHealthDataAvailable() {
            print("No health data is available.")
            completionHandler(false)
            return
        }

        // Create quantity type for heart rate.
        guard let heartRateQuantityType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            print("Unable to create quantity type for heart rate.")
            completionHandler(false)
            return
        }

        // Request authorization to read heart rate data.
        print("before healthStore.requestAuthorization")
        healthStore.requestAuthorization(toShare: nil, read: [heartRateQuantityType, HKObjectType.workoutType()]) { (success, error) -> Void in
            print("in healthStore.requestAuthorization")
            // If there is an error, do nothing.
            guard error == nil else {
                // print("in healthStore.requestAuthorization.error: \(error.debugDescription))")
                print(error as Any)
                completionHandler(false)
                return
            }

            // Delegate success.
            completionHandler(success)
        }
    }

}
