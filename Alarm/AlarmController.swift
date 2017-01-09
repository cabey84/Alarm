//
//  AlarmController.swift
//  Alarm
//
//  Created by Chandi Abey  on 8/26/16.
//  Copyright © 2016 Chandi Abey . All rights reserved.
//

import Foundation
import UIKit

class AlarmController {
    
    //creates a shared controller property as a shared instance
    static let sharedController = AlarmController()
    
    //array of alarms
    var alarms: [Alarm] = [ ]
   
    
    //initialize 
    init() {
        loadFromPersistentStorage()
        self.alarms = mockAlarms
    }
    
    
    //Adding mock alarm data using a computed property
    
    var mockAlarms: [Alarm] {
        let alarm1 = Alarm(fireTimeFromMidnight: 3600, name: "Almost Midnight")
        let alarm2 = Alarm(fireTimeFromMidnight: 18000, name: "Get Ready for Bed")
        let alarm3 = Alarm(fireTimeFromMidnight: 43200, name: "Time For Lunch")
        
        
       return  [alarm1, alarm2, alarm3]
        
    }
    
    //REFERENCE CODE- assignign a property to itself error
    //create an initializer. When you want mock data, set self.alarms to self.alarms. Remove it when you no longer want mock data 
   

    //MARK: Model Controller basics
    func addAlarm(_ fireTimeFromMidnight: TimeInterval, name: String) {
        let alarm = Alarm(fireTimeFromMidnight: fireTimeFromMidnight, name: name)
        alarms.append(alarm)
        saveToPersistentStorage()
    }
    
    
    func updateAlarm(_ alarm: Alarm, fireTimeFromMidnight: TimeInterval, name: String) {
        alarm.fireTimeFromMidnight = fireTimeFromMidnight
        alarm.name = name
        saveToPersistentStorage()
    }
    
    func deleteAlarm(_ alarm: Alarm) {
        //use guard statement since indexOf returns an optional
        guard let index = alarms.index(of: alarm) else { return  }
        alarms.remove(at: index)
        saveToPersistentStorage()
    }
    
    
    func toggleEnabled(_ alarm: Alarm) {
        alarm.enabled = !alarm.enabled
        saveToPersistentStorage()
        
    }
    
    
    //MARK: Load/Save
    
    private func saveToPersistentStorage() {
        guard let filePath = type(of: self).persistentAlarmsFilePath else { return }
        NSKeyedArchiver.archiveRootObject(self.alarms, toFile: filePath)
    }
    
    private func loadFromPersistentStorage() {
        guard let filePath = type(of: self).persistentAlarmsFilePath else { return }
        guard let alarms = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Alarm] else { return }
        self.alarms = alarms
    }
 
    //MARK:- Helpers
    
    static private var persistentAlarmsFilePath: String? {
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        guard let documentsDirectory = directories.first as NSString? else { return nil }
        return documentsDirectory.appendingPathComponent("Alarms.plist")
    }
    
}



//MARK: - AlarmScheduler

protocol AlarmScheduler {
    func scheduleLocalNotification(for alarm: Alarm)
    func cancelLocalNotification(for alarm: Alarm)
}

extension AlarmScheduler {
    //implement default implementations for the two protocol functions 
    func scheduleLocalNotification(for alarm: Alarm) {
        let localNotification = UILocalNotification()
        localNotification.userInfo = ["UUID": alarm.uuid]
        localNotification.alertTitle = "Time's up!"
        localNotification.alertBody = "Your alarm titled \(alarm.name) is done"
        localNotification.fireDate = alarm.fireDate as Date?
        localNotification.repeatInterval = .day
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
    
    func cancelLocalNotification(for alarm: Alarm) {
        guard let scheduledNotifications = UIApplication.shared.scheduledLocalNotifications else { return }
        for notification in scheduledNotifications {
            guard let uuid = notification.userInfo?["UUID"] as? String, uuid == alarm.uuid else { continue }
            UIApplication.shared.cancelLocalNotification(notification)
        }
    }
    
    
}
