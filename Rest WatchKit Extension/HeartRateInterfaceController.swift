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
    @IBOutlet var informationFromBpmLabel: WKInterfaceLabel!
    @IBOutlet var informationToBpmLabel: WKInterfaceLabel!
    @IBOutlet var informationInTimeLabel: WKInterfaceLabel!
    @IBOutlet var informationTargetBpmLabel: WKInterfaceLabel!
    @IBOutlet var messageLabel: WKInterfaceLabel!

    private let restSessionManager = RestSessionManager()
    private var targetValue: Int = 55
    private var timestampStart: Date = Date()
    private var timestampEnd: Date = Date()
    private var lastHeartRate: Int = -1
    private var firstHeartRate: Int = -1

    override func awake(withContext context: Any?) {
        restSessionManager.delegate = self
        initUI()
        startRest()
        // restSessionManager.start()
        initData(context: context as? NSDictionary)
    }

    override func willActivate() {
        super.willActivate()
    }

    func initUI() {
        setTitle("Back")
        clearInformation()
    }

    func initData(context: NSDictionary?) {
        guard let targetValueFromContext = context?["data"] as? Int else { return }
        targetValue = targetValueFromContext
    }

    func clearInformation() {
        heartRateLabel.setText("--")
        informationFromBpmLabel.setText("")
        informationToBpmLabel.setText("")
        informationInTimeLabel.setText("")
        informationTargetBpmLabel.setText("")
        messageLabel.setText("")
    }

    func startRest() {
        clearInformation()
        restSessionManager.start()
        timestampStart = Date()
    }

    func stopRest() {
        restSessionManager.stop()
        timestampEnd = Date()
        displayInformationEndSession()
    }

    @IBAction func didTapButton() {
        switch restSessionManager.state {
        case .started:
            // Stop current rest session.
            stopRest()
            break
        case .stopped:
            // Start new rest session.
            startRest()
            break
        }
    }

    func displayInformationEndSession() {
        if firstHeartRate == -1 {
            informationFromBpmLabel.setText("Not enough data")
            informationToBpmLabel.setText("I need more time...")
        } else {
            informationFromBpmLabel.setText("From: \(firstHeartRate) bpm")
            informationToBpmLabel.setText("To: \(lastHeartRate) bpm")
            informationInTimeLabel.setText("Time: \(timestampEnd.offset(from: timestampStart))")
            informationTargetBpmLabel.setText("Target: \(targetValue) bpm")
        }
    }

    func updateData(heartRate: Int) {
        if firstHeartRate == -1 {
            firstHeartRate = heartRate
        }
        lastHeartRate = heartRate
        if heartRate <= targetValue {
            success()
            stopRest()
            messageLabel.setText("Congratulations!")
        }
    }

    override func willDisappear() {
        restSessionManager.stop()
    }

    func success() {
        WKInterfaceDevice.current().play(.success)
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
        updateData(heartRate: newHeartRate.bpm)
        let bpm = "\(newHeartRate.bpm) bpm"
        heartRateLabel.setText(bpm)
    }

}
