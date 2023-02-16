//
//  PZXEventAddManager.swift
//  addDateTest
//
//  Created by pzx on 2023/2/16.
//

import UIKit
import EventKit

typealias PZXEventAddManagerBlock = (Bool) -> ()// 声明闭包

class PZXEventAddManager: NSObject {
    
    static let sharedManager = PZXEventAddManager()
    
    var callback :PZXEventAddManagerBlock? //把闭包声明成属性
    
    /// 添加提醒事项列表
    /// - Parameter title: 标题
    /// - Parameter isSuccess: 回调- true 成功 false 失败
    public func ReminderCalendarAdd(title:String,isSuccess:PZXEventAddManagerBlock!){
        
        
        let array =  PZXEventStore.eventStore.calendars(for: .reminder)
        for calendar :EKCalendar in array {
            print("列表：\(calendar.title)")
            //如果已经有这个calendar了 就不添加了
            if calendar.title == title {
                return
            }
        }
        
        //添加
        let calendar = EKCalendar.init(for: .reminder, eventStore: PZXEventStore.eventStore);
        if PZXEventStore.eventStore.sources.count == 0 { // reproducible after Reset Content and Settings
               calendar.source = EKSource()
           }else {
               calendar.source = PZXEventStore.eventStore.defaultCalendarForNewReminders()!.source
           }
        
        calendar.title = title
        calendar.cgColor = UIColor.red.cgColor
        
        do{
            try PZXEventStore.eventStore.saveCalendar(calendar, commit: true)
            debugPrint("成功加入")
            isSuccess(true)
        }catch  {
            isSuccess(false)
            debugPrint(error)
        }
        
        
        
    }
    
    
    /// 添加提醒事项
    /// - Parameters:
    ///   - title: 标题
    ///   - notes: 备注
    ///   - date: 提醒日期
    ///   - isSuccess:  回调- true 成功 false 失败
    public func reminderAdd(calendartitle:String,title:String,notes : String,date : Date,isSuccess:PZXEventAddManagerBlock!){
        
        let reminder = EKReminder.init(eventStore: PZXEventStore.eventStore);
        reminder.title = title;
        reminder.notes = notes
        
        if (calendartitle.count == 0){
            reminder.calendar = PZXEventStore.eventStore.defaultCalendarForNewReminders();
        }else {
            
            let array =  PZXEventStore.eventStore.calendars(for: .reminder)
            for calendar :EKCalendar in array {
                //如果已经有这个calendar了 就不添加了
                if calendar.title == calendartitle {
                    reminder.calendar = calendar;
                }
            }
            
        }

        let alarm = EKAlarm(absoluteDate: date)
        reminder.addAlarm(alarm)
        do {
          try PZXEventStore.eventStore.save(reminder, commit: true)
            isSuccess(true)

        } catch {
          print("save reminder error: \(error)")
            isSuccess(false)

        }
        
        
    }
    
    
    /// 添加日历事件
    /// - Parameters:
    ///   - title: 标题
    ///   - notes: 备注
    ///   - startDate: 开始时间
    /// - Parameter isSuccess: 回调- true 成功 false 失败
    public func eventAdd(title:String,notes : String,startDate : Date,isSuccess:PZXEventAddManagerBlock!){
        
        let event:EKEvent = EKEvent(eventStore: PZXEventStore.eventStore);
        event.title = title
        event.notes = notes
        event.startDate = startDate
        event.endDate = Date().addingTimeInterval(1000)
        event.calendar = PZXEventStore.eventStore.defaultCalendarForNewEvents
        let alarm = EKAlarm(absoluteDate: startDate)
        event.addAlarm(alarm)
        do {
          try PZXEventStore.eventStore.save(event, span: .futureEvents, commit: true)
            debugPrint("Saved Event")
            isSuccess(true)

        } catch {
          print("save calendar error:\(error)")
            isSuccess(false)

        }

        
    }
    
    
    /// 判断日历权限
    public func judgeEventAuth() {
        
        PZXEventStore.eventStore.requestAccess(to: .event) { (granted, error) in
            
            if !granted {
                let alertViewController = UIAlertController(title: "提示", message: "请在iPhone的\"设置->隐私->日历\"选项中,允许访问你的日历。", preferredStyle: .alert)
                let actionCancel = UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                })
                let actinSure = UIAlertAction(title: "设置", style: .default, handler: { (action) in
                    //跳转到系统设置主页
                    if let url = URL(string: UIApplication.openSettingsURLString) {
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
                // FIXME: - 弹出这个alertViewController
            }
            
            
        }
        
    }
    
    
    /// 判断提醒事项权限
    public func judgeReminderAuth() {
        
        PZXEventStore.eventStore.requestAccess(to: .reminder) { (granted, error) in
            
            if !granted {
                let alertViewController = UIAlertController(title: "提示", message: "请在iPhone的\"设置->隐私->提醒事项\"选项中,允许访问你的提醒事项。", preferredStyle: .alert)
                let actionCancel = UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                })
                let actinSure = UIAlertAction(title: "设置", style: .default, handler: { (action) in
                    //跳转到系统设置主页
                    if let url = URL(string: UIApplication.openSettingsURLString) {
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
                // FIXME: - 弹出这个alertViewController
            }
            
            
        }
        
    }
    
    
}
