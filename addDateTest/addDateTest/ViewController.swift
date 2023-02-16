//
//  ViewController.swift
//  addDateTest
//
//  Created by pzx on 2023/2/16.
//

import UIKit
import EventKit

class ViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        PZXEventAddManager.sharedManager.judgeEventAuth()
        PZXEventAddManager.sharedManager.judgeReminderAuth()
        let array =  PZXEventStore.eventStore.calendars(for: .reminder)
    
 
        
        for calendar :EKCalendar in array {
            
            print("列表：\(calendar.title)")
            if calendar.title == "测试" {

                
                calendar.title = "修改测试"
                do {
                    try PZXEventStore.eventStore.saveCalendar(calendar, commit: true);
                    debugPrint("删除成功")
                } catch  {
                    debugPrint("删除失败")
                }


            }
        }
        
  

      
    }

    @IBAction func ButtonPressed(_ sender: UIButton) {
        
        
        PZXEventAddManager.sharedManager.ReminderCalendarAdd(title: "饭局助手")
        PZXEventAddManager.sharedManager.reminderAdd(calendartitle: "饭局助手", title: "测试标题", notes: "测试备注", date: Date())

        
        
        
    }
    
    
    
    
}

