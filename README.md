# Alarm
Simple alarm app using intermediate table view features, protocols, the delegate pattern, NSCoding, UILocalNotifications, and UIAlertControllers.

    
Takeaways: 

1. Static table views
   a. Detail view, static table views should be used sparingly, but they can be useful for a table view that will never change, such as a basic form. You can make a table view static by selecting the table view on the UITableViewController, going to the Attribute Inspector, and changing the content dropdown from Dynamic Prototypes to Static Cells.
   b. Static table views do not need to have UITableViewDataSource functions implemented. Instead, you can create outlets and actions from your prototype cells directly onto the view controller (in this case AlarmDetailTableViewController) as you would with other types of views.
   c. Detail table view and in the Attribute Inspector change the style to grouped and the sections to 3.
2. Custom Tableview cells
    a. best practice to make table view cells reusable between apps so SwitchTableViewCell rather than an AlarmTableViewCell that can be reused any time you want a cell with a switch. 
    b.  create an alarm property with a didSet observer used to populate the cell with details about the alarm.
3. Delegate Pattern- Custom UITableViewCell
    a. SwitchTableViewCell
        1. protocol for the SwitchTableViewCell to delegate handling a toggle of the switch to the AlarmListTableViewController using switch function, must be restricted to class types 
        2. add a weak optional delegate property of type SwitchTableViewCellDelegate? 
        3. update switchValueChanged action to check if a delegate is assigned and if so, call the protocol function
    b. Table VC
        1. adopt the protocol
        2. Implement the switchCellSwitchValueChanged(cell:) delegate function to capture the alarm as a variable, toggle alarm's enabled property and reload the table view.
4. NSDate and NSDateComponents 
5. NSCoding Protocol to the Model Object 
    a. model objects that conform to NSCoding protocol
    b. add the required init?(coder aDecoder: NSCoder) and encodeWithCoder(aCoder: NSCoder) functions- Inside each, you will use the NSCoder provided from the initializer or function to either encode your properties using aCoder.encodeObject(object, forKey: key) or decode your properties using aDecoder.decodeObjectForKey(key).
    c. note: It is best practice to create static internal keys to use in encoding and decoding (ex. private let kName = "name")
6. NSKeyedArchiver and NSKeyedUnarchiver data persistence to Model Controller
    a. Archiving is similar to working with NSUserDefaults, but uses NSCoders to serialize and deserialize objects instead of our initWithDictionary and dictionaryRepresentation functions. Both are valuable to know and be comfortable with.
    b. NSKeyedArchiver serializes objects and saves them to a file on the device. NSKeyedUnarchiver pulls that file and deserializes the data back into our model objects. Because of the way that iOS implements security and sandboxing, each application has it's own 'Documents' directory that has a different path each time the application is launched. When you want to write to or read from that directory, you need to first search for the directory, then capture the path as a reference to use where needed.
   c. It is best to separate that logic into a separate function that returns the path. Here is an example function that accespt a string as a key and will return the path to a file in the Documents directory with that name. 
      static private var persistentAlarmsFilePath: String? {
         let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
         guard let documentsDirectory = directories.first as NSString? else { return nil }
          return documentsDirectory.appendingPathComponent("Alarms.plist")
       }

Add a private, static, computed property called persistentAlarmsFilePath which returns the correct path to the alarms file in the app's documents directory as described above.
Write a private function called saveToPersistentStorage() that will save the current alarms array to a file using NSKeyedArchiver
note: `NSKeyedArchiver.archiveRootObject(self.alarms, toFile: persistentAlarmsFilePath)
Write a function called loadFromPersistentStorage() that will load saved Alarm objects and set self.alarms to the results
note: Capture the data using NSKeyedUnarchiver.unarchiveObjectWithFile(persistentAlarmsFilePath), unwrap the Optional results and set self.alarms
Call the loadFromPersistentStorage() function when the AlarmController is initialized
Call the saveToPersistentStorage() any time that the list of alarms is modified
note: You should now be able to see that your alarms are saved between app launches.



1. UIAlertControllers 
2. UILocalNotifications
       In the AppDelegate.swift file in the application(_:didFinishLaunchingWithOptions:) function, create an instance of UIUserNotificationSettings.
Using the above settings, register user notification settings with the application's shared application.
note: Without this, the user will not ever be notified, even if you have schedule a local notification

1. Custom Protocols and Protocol extensions- to define protocol function behavior across all conforming types scheduling and cancelling local notifications 

1. Property observer pattern on the SwitchTableViewCell class 
a didSet observer that updates the labels to the time and name of the alarm, and updates the alarmSwitch.on property so that the switch reflects the proper alarm enabled state.
1. Detail view: Create a didSet property observer on the alarm property that will call updateViews() when the alarm property changes.


Schedule and Cancel Local Notifications using a Custom Protocol and Extension

Using a custom protocol and a protocol extension, we can write protocol functions only once, and use them in each of our view controllers as if we had written them in each view controller. by adding an extension to the protocol, we have created the implementation of these functions for all classes that conform to the protocol.

scheduleLocalNotification(for alarm: Alarm) function should create an instance of a UILocalNotification, give it an alert title, alert body, and fire date. also need to set it's category property to something unique, also be set to repeat at one day intervals. 
You will then need to schedule this local notification with the application's shared application.

Your cancelLocalnotification(for alarm: Alarm) function will need to get all of the application's scheduled notifications using UIApplication.sharedApplication.scheduledLocalNotifications. This will give you an array of local notifications. You can loop through them and cancel the local notifications whose category matches the alarm using UIApplication.sharedApplication.cancelLocalNotification(notification: notification).
Now go to your list view controller and detail view controller and make them conform to the AlarmScheduler protocol.  

Go to your AlarmListTableViewController. In your switchCellSwitchValueChanged function you will need to schedule a notification if the switch is being turned on, and cancel the notification if the switch is being turned off. You will also need to cancel the notification when you delete an alarm.
Go to your AlarmDetailTableViewController. Your enableButtonTapped action will need to either schedule or cancel a notification depending on its state, and will also need to call your AlarmController.sharedInstance.toggleEnabled(for alarm: Alarm) function if it isn't being called already. Your saveButtonTapped method will need to schedule a notification when saving a brand new alarm, and will need to cancel and re-set a notification when saving existing alarms (this is because the user may have changed the time for the alarm).
Present a UIAlertController



Go to the AppDelegate.swift file and add the function application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification). This will be called when a local notification fires and the user has the app opened.

Initialize a UIAlertController of style .Alert. Add a dismiss action to it, and present it from the window?.rootViewController property.
