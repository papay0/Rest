//
//  HeartRateInterfaceController.swift
//  Rest
//
//  Created by Arthur Papailhau on 5/6/17.
//  Copyright © 2017 Arthur Papailhau. All rights reserved.
//

import WatchKit
import Foundation

class HeartRateInterfaceController: WKInterfaceController {

    @IBOutlet var controlButton: WKInterfaceButton!
    @IBOutlet var heartRateLabel: WKInterfaceLabel!

    private let restSessionManager = RestSessionManager()

    override func willActivate() {
        super.willActivate()
        restSessionManager.delegate = self
        restSessionManager.start()
    }

    @IBAction func didTapButton() {
        switch restSessionManager.state {
        case .started:
            // Stop current workout.
            restSessionManager.stop()
            break
        case .stopped:
            // Start new workout.
            restSessionManager.start()
            break
        }
    }

}

// MARK: - Rest Session Manager Delegate

extension HeartRateInterfaceController: RestSessionManagerDelegate {

    func restSessionManager(_ manager: RestSessionManager, didChangeStateTo newState: RestSessionState) {
        // Update title of control button.
        controlButton.setTitle(newState.actionText())
    }

    func restSessionManager(_ manager: RestSessionManager, didChangeHeartRateTo newHeartRate: HeartRate) {
        // Update heart rate label.
        print("new value: \(newHeartRate.bpm)")
        heartRateLabel.setText(String(format: "%.0f", newHeartRate.bpm))
    }

}
