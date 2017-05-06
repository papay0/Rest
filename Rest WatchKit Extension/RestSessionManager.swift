//
//  RestSessionManager.swift
//  Rest
//
//  Created by Arthur Papailhau on 5/6/17.
//  Copyright © 2017 Arthur Papailhau. All rights reserved.
//

import HealthKit

enum RestSessionState {

    case started, stopped

}

extension RestSessionState {

    func actionText() -> String {
        switch self {
        case .started:
            return "Stop"
        case .stopped:
            return "Start"
        }
    }

}

protocol RestSessionManagerDelegate: class {

    func restSessionManager(_ manager: RestSessionManager, didChangeStateTo newState: RestSessionState)
    func restSessionManager(_ manager: RestSessionManager, didChangeHeartRateTo newHeartRate: HeartRate)

}

class RestSessionManager: NSObject {

    // MARK: - Properties

    private let healthStore = HKHealthStore()
    fileprivate let heartRateManager = HeartRateManager()

    weak var delegate: RestSessionManagerDelegate?

    private(set) var state: RestSessionState = .stopped

    private var session: HKWorkoutSession?

    // MARK: - Initialization

    override init() {
        super.init()

        // Configure heart rate manager.
        heartRateManager.delegate = self
    }

    // MARK: - Public API

    func start() {
        print("start rest session")
        // If we have already started the workout, then do nothing.
        if session != nil {
            // Another workout is running.
            return
        }

        // Configure the workout session.
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .other
        workoutConfiguration.locationType = .indoor

        // Create workout session.
        do {
            session = try HKWorkoutSession(configuration: workoutConfiguration)
            session!.delegate = self
        } catch {
            fatalError("Unable to create Workout Session!")
        }

        // Start workout session.
        healthStore.start(session!)

        // Update state to started and inform delegates.
        state = .started
        delegate?.restSessionManager(self, didChangeStateTo: state)
    }

    func stop() {
        print("stop rest session")
        // If we have already stopped the workout, then do nothing.
        if session == nil {
            return
        }

        // Stop querying heart rate.
        heartRateManager.stop()

        // Stop the workout session.
        healthStore.end(session!)

        // Clear the workout session.
        session = nil

        // Update state to stopped and inform delegates.
        state = .stopped
        delegate?.restSessionManager(self, didChangeStateTo: state)
    }

}

// MARK: - Workout Session Delegate

extension RestSessionManager: HKWorkoutSessionDelegate {

    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        switch toState {
        case .running:
            if fromState == .notStarted {
                heartRateManager.start()
            }

        default:
            break
        }
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        fatalError(error.localizedDescription)
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didGenerate event: HKWorkoutEvent) {
        print("Did generate \(event)")
    }

}

// MARK: - Heart Rate Delegate

extension RestSessionManager: HeartRateManagerDelegate {

    func heartRate(didChangeTo newHeartRate: HeartRate) {
        delegate?.restSessionManager(self, didChangeHeartRateTo: newHeartRate)
    }

}
