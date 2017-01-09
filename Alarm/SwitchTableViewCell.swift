//
//  SwitchTableViewCell.swift
//  Alarm
//
//  Created by Chandi Abey  on 8/26/16.
//  Copyright © 2016 Chandi Abey . All rights reserved.
//

import UIKit

//require the delgate to have adopted the delegate protocol
class SwitchTableViewCell: UITableViewCell  {

    //add a weak optional delegate property, requiring the delegate to have adopted the delegate protocol
    //call this switchtableviewcelldelegate instead of table view 
    weak var delegate: SwitchTableViewCellDelegate?
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    //ASK FOR AN EXPLANATION ABOUT WHAT IS GOING ON HERE. 
    @IBAction func switchButtonTapped(_ sender: AnyObject) {
        //check if a delegate is assigned and if so, call the delegate protocol function- REFERENCED CODE, we set up the delegate, it has all the functions, now tableview controller is handling it.
            delegate?.switchCellSwitchValueChanged(self)
        }
    
    
    //updates the labels to the time and name of the alarm and calls the updates the alarmSwitch.on property so the switch reflects the proper alarm enabled state
    //func updateWithAlarm(_ alarm: Alarm) {
    
    
    var alarm: Alarm? {
        didSet {
            guard let alarm = alarm else { return }
            timeLabel.text? = alarm.fireTimeAsString
            nameLabel.text? = alarm.name
            alarmSwitch.isOn = alarm.enabled
        }
    }
    

}

//write a protocol to delegate handling a toggle of the switch to the tableviewcontroller, adopt the protocol and use the delegate function to mark the alarm as enabled or disabled and reload the cell. protocol of type class to prevent compiler from throwing an error.

protocol SwitchTableViewCellDelegate: class {
    func switchCellSwitchValueChanged(_ cell: SwitchTableViewCell)

}
