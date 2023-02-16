//
//  EventCalendar.swift
//  addDateTest
//
//  Created by pzx on 2023/2/16.
//

import UIKit
import EventKit
class EventCalendar: NSObject {
    //单例
    static let eventStore = EKEventStore()
    
    ///用户是否授权使用日历
    func isEventStatus() -> Bool {
        let eventStatus = EKEventStore.authorizationStatus(for: EKEntityType.event)
        if eventStatus == .denied || eventStatus == .restricted {
            return false
        }
        return true
    }
}

EventCalendar.eventStore.requestAccess(to: EKEntityType.event) { [self] (granted, error) in
//用户没授权
                if !granted {
                    let alertViewController = UIAlertController(title: "提示", message: "请在iPhone的\"设置->隐私->日历\"选项中,允许***访问你的日历。", preferredStyle: .alert)
                    let actionCancel = UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                    })
                    let actinSure = UIAlertAction(title: "设置", style: .default, handler: { (action) in
                        //跳转到系统设置主页
                        if let url = URL(string: UIApplicationOpenSettingsURLString) {
                            //根据iOS系统版本，分别处理
                            if #available(iOS 10, *) {
                                UIApplication.shared.open(url)
                            } else {
                                UIApplication.shared.openURL(url)
                            }
                        }
                    })
                    alertViewController.addAction(actionCancel)
                    alertViewController.addAction(actinSure)
                    self.present(alertViewController, animated: true, completion: nil)
                    return
                }
}
