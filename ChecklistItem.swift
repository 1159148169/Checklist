//
//  ChecklistItem.swift
//  CheckListTest
//
//  Created by Shi Feng on 16/4/9.
//  Copyright © 2016年 Shi Feng. All rights reserved.
//

import Foundation
import UIKit

class ChecklistItem:NSObject,NSCoding {
    var text = ""
    var checked = false
    
    var dueDate = NSDate()
    var shouldRemind = false
    var itemID:Int
    
    func toggleChecked() {
        checked = !checked
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeBool(checked, forKey: "Checked")
        aCoder.encodeObject(dueDate, forKey: "DueDate")
        aCoder.encodeBool(shouldRemind, forKey: "ShouldRemind")
        aCoder.encodeInteger(itemID, forKey: "ItemID")
    }
    func scheduleNotification() {
        let existingNotification = notificationForThisItem()
        if let notification = existingNotification {
            //print("Found an existing notification \(notification)")
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
        if shouldRemind && dueDate.compare(NSDate()) != .OrderedAscending {
            let localNotification = UILocalNotification()
            localNotification.fireDate = dueDate
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            localNotification.alertBody = "亲,别忘了今天的任务:\(text)"
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.userInfo = ["ItemID": itemID]
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            //print("Scheduled notification \(localNotification) for itemID \(itemID)")
        }
    }
    
    func notificationForThisItem() -> UILocalNotification? {
        let allNotifications =
        UIApplication.sharedApplication().scheduledLocalNotifications!
        for notification in allNotifications {
            if let number = notification.userInfo?["ItemID"] as? Int
                where number == itemID {
                return notification
            }
        }
        return nil
    }
    required init?(coder aDecoder: NSCoder) { //文件读取
        text = aDecoder.decodeObjectForKey("Text") as! String
        checked = aDecoder.decodeBoolForKey("Checked")
        dueDate = aDecoder.decodeObjectForKey("DueDate") as! NSDate
        shouldRemind = aDecoder.decodeBoolForKey("ShouldRemind")
        itemID = aDecoder.decodeIntegerForKey("ItemID")
        super.init()
    }
    override init() {
        itemID = DataModel.nextChecklistItemID() //当APP创建一个新的ChecklistItem时向DataModel要求一个新的ItemID
        super.init()
    }
    deinit {
        if let notification = notificationForThisItem() {
            //print("Removing existing notification \(notification)")
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
    }
}