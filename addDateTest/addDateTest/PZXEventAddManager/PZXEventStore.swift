//
//  PZXEventStore.swift
//  addDateTest
//
//  Created by pzx on 2023/2/16.
//

import UIKit
import EventKit

class PZXEventStore: NSObject {
    
    static let eventStore = EKEventStore()
    
    ///用户是否授权使用日历
    func isEventStatus() -> Bool {
        let eventStatus = EKEventStore.authorizationStatus(for: EKEntityType.event)
        if eventStatus == .denied || eventStatus == .restricted {
            return false
        }
        return true
    }
    
    ///用户是否授权使用提醒事项
    func isReminderStatus() -> Bool {
        let eventStatus = EKEventStore.authorizationStatus(for: EKEntityType.reminder)
        if eventStatus == .denied || eventStatus == .restricted {
            return false
        }
        return true
    }

}
