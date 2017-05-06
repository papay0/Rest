//
//  HKUnit+BeatsPerMinute.swift
//  Rest
//
//  Created by Arthur Papailhau on 5/6/17.
//  Copyright © 2017 Arthur Papailhau. All rights reserved.
//

import HealthKit

extension HKUnit {

    static func beatsPerMinute() -> HKUnit {
        return HKUnit.count().unitDivided(by: HKUnit.minute())
    }

}
