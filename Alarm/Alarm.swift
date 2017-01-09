//
//  Alarm.swift
//  Alarm
//
//  Created by Chandi Abey  on 8/26/16.
//  Copyright © 2016 Chandi Abey . All rights reserved.
//

import Foundation



//creates an alarm model class that will hold a fireTimeFromMidnight, name, enabled property and computed proeprties for fireDate adn fireTimeAsString.

class Alarm: NSObject, NSCoding {
    fileprivate let kFireTimeFromMidnight = "fireTimeFromMidnight"
    fileprivate let kName = "name"
    fileprivate let kEnabled = "enabled"
    fileprivate let kUUID = "UUID"
    
    init(fireTimeFromMidnight: TimeInterval, name: String, enabled: Bool = true, uuid: String = UUID().uuidString) {
        self.fireTimeFromMidnight = fireTimeFromMidnight
        self.name = name
        self.enabled = enabled
        self.uuid = uuid
    }
    
    
    
    //MARK: - NSCoding
    required init?(coder aDecoder: NSCoder) {
        guard let fireTimeFromMidnight = aDecoder.decodeObject(forKey: kFireTimeFromMidnight) as? TimeInterval,
            let name = aDecoder.decodeObject(forKey: kName) as? String,
            let enabled = aDecoder.decodeObject(forKey: kEnabled) as? Bool,
            let uuid = aDecoder.decodeObject(forKey: kUUID) as? String else {return nil}
        self.fireTimeFromMidnight = fireTimeFromMidnight
        self.name = name
        self.enabled = enabled
        self.uuid = uuid
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(fireTimeFromMidnight, forKey: kFireTimeFromMidnight)
        aCoder.encode(name, forKey: kName)
        aCoder.encode(enabled, forKey: kEnabled)
        aCoder.encode(uuid, forKey: kUUID)
    }
    
    //MARK: - Properties
    
    //stores the time of day taht the alarm should go off
    //NSInterval represents the  number of seconds from midnight
    var fireTimeFromMidnight: TimeInterval
    var name: String
    var enabled: Bool
    //universally unique identifier. will be used later to schedule and cancel local notifications. 
    let uuid: String
    
    //will be used in part 2 of the project to schedule notifications to the user for the alarm
    var fireDate: Date? {
        guard let thisMorningAtMidnight = DateHelper.thisMorningAtMidnight else {return nil}
        let fireDateFromThisMorning = Date(timeInterval: fireTimeFromMidnight, since: thisMorningAtMidnight as Date)
        return fireDateFromThisMorning
    }
    
    //used to dispaly the time of day that the alarm should go off
    var fireTimeAsString: String {
        let fireTimeFromMidnight = Int(self.fireTimeFromMidnight)
        var hours = fireTimeFromMidnight/60/60
        let minutes = (fireTimeFromMidnight - (hours*60*60))/60
        if hours >= 13 {
            return String(format: "%2d:%02d PM", arguments: [hours - 12, minutes])
        } else if hours >= 12 {
            return String(format: "%2d:%02d PM", arguments: [hours, minutes])
        } else {
            if hours == 0 {
                hours = 12
            }
            return String(format: "%2d:%02d AM", arguments: [hours, minutes])
        }
    }
    
}


//MARK:- Equatable 

func ==(lhs: Alarm, rhs: Alarm) -> Bool {
    return lhs.uuid == rhs.uuid
}
