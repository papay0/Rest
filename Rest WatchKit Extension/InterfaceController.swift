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

    @IBOutlet var heartRateTargetPicker: WKInterfacePicker!

    private let heartRateTargetItems: [WKPickerItem] = []
    private var heartRateTargetValue: Int!
    private let minimumHeartRateTarget = 20
    private let maximumHeartRateTarget = 260

    override func awake(withContext context: Any?) {
        initializeHeartRatePicker(minimumHeartRateTarget: minimumHeartRateTarget, maximumHeartRateTarget: maximumHeartRateTarget, picker: heartRateTargetPicker)
    }

    @IBAction func didTapButton() {
        // pushController(withName: "HeartRateInterfaceController", context: nil)
    }

    @IBAction func heartRateTargetActionPicker(_ value: Int) {
        heartRateTargetValue = getTargetValueByIndexPicker(minimumHeartRateTarget: minimumHeartRateTarget, index: value)
    }

    func initializeHeartRatePicker(minimumHeartRateTarget: Int, maximumHeartRateTarget: Int, picker: WKInterfacePicker) {
        var pickerItems: [WKPickerItem] = []
        let initialIndex = 35

        for heartRateTarget in minimumHeartRateTarget ... maximumHeartRateTarget {
            let heartRatePickerItem: WKPickerItem = WKPickerItem()
            heartRatePickerItem.title = "\(heartRateTarget) bpm"
            pickerItems.append(heartRatePickerItem)
        }

        picker.setItems(pickerItems)
        picker.setSelectedItemIndex(initialIndex)
        heartRateTargetValue = initialIndex + minimumHeartRateTarget
    }

    func getTargetValueByIndexPicker(minimumHeartRateTarget: Int, index: Int) -> Int {
        return index + minimumHeartRateTarget
    }

    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        let segueData: [String : Any] = ["segue": "HeartRateInterfaceController",
        "data": heartRateTargetValue]
        if segueIdentifier == "HeartRateInterfaceController" {
            return segueData
        }
        return segueData
    }

}
