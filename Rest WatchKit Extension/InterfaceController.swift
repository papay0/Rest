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

    override func willActivate() {
        super.willActivate()
        initializeHeartRatePicker(picker: heartRateTargetPicker)
    }

    func initializeHeartRatePicker(picker: WKInterfacePicker) {
        let minimumHeartRateTarget = 20
        let maximumHeartRateTarget = 260
        var pickerItems: [WKPickerItem] = []

        for heartRateTarget in minimumHeartRateTarget ... maximumHeartRateTarget {
            let heartRatePickerItem: WKPickerItem = WKPickerItem()
            heartRatePickerItem.title = "\(heartRateTarget) bpm"
            pickerItems.append(heartRatePickerItem)
        }

        picker.setItems(pickerItems)
        picker.setSelectedItemIndex(35)
    }

}
