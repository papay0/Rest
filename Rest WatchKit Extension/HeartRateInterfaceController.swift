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

    override func awake(withContext context: Any?) {
        print("in awake(withContext context)")
        restSessionManager.delegate = self
        restSessionManager.start()
        setTitle("Back")
    }
    
    override func willActivate() {
        print("in willActivate")
        super.willActivate()
    }

    @IBAction func didTapButton() {
        switch restSessionManager.state {
        case .started:
            // Stop current rest session.
            restSessionManager.stop()
            // pushController(withName: "InterfaceController", context: nil)
            break
        case .stopped:
            // Start new rest session.
            restSessionManager.start()
            break
        }
    }

    override func willDisappear() {
        restSessionManager.stop()
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
        let bpm = "\(String(format: "%.0f", newHeartRate.bpm)) bpm"
        heartRateLabel.setText(bpm)
    }

}
