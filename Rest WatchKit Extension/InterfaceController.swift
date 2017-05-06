//
//  InterfaceController.swift
//  Rest WatchKit Extension
//
//  Created by Arthur Papailhau on 5/6/17.
//  Copyright © 2017 Arthur Papailhau. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {

    @IBOutlet var heartRateLabel: WKInterfaceLabel!
    @IBOutlet var controlButton: WKInterfaceButton!

    private let restSessionManager = RestSessionManager()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        // Configure interface objects here.
    }

    private let heartRateManager = HeartRateManager()

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        restSessionManager.delegate = self
    }

    // MARK: - Actions

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

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

// MARK: - Rest Session Manager Delegate

extension InterfaceController: RestSessionManagerDelegate {

    func restSessionManager(_ manager: RestSessionManager, didChangeStateTo newState: RestSessionState) {
        // Update title of control button.
        controlButton.setTitle(newState.actionText())
    }

    func restSessionManager(_ manager: RestSessionManager, didChangeHeartRateTo newHeartRate: HeartRate) {
        // Update heart rate label.
        heartRateLabel.setText(String(format: "%.0f", newHeartRate.bpm))
    }

}
