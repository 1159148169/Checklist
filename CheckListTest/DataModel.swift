//
//  DataModel.swift
//  CheckListTest
//
//  Created by Shi Feng on 16/5/11.
//  Copyright © 2016年 Shi Feng. All rights reserved.
//

import Foundation
import UIKit

class DataModel {
    var lists = [Checklist]()
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    //以下代码涉及文件存储操作(替换到了其他的位置)
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
    func dataFilePath() -> String {
        return (documentsDirectory() as NSString).stringByAppendingPathComponent("Checklists.plist") //文件存储在Checklists.plist中
    }
    
    func saveChecklists() { //保存
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(lists, forKey: "Checklists")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    func loadChecklists() { //读取
        let path = dataFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                lists = unarchiver.decodeObjectForKey("Checklists") as! [Checklist]
                unarchiver.finishDecoding()
                sortChecklists()
            }
        }
    }
    
    func registerDefaults() {
        let dictionary = [ "ChecklistIndex": -1,
                           "FirstTime": true,
                           "ChecklistItemID": 0]
        NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)
    }
    
    func handleFirstTime() { //应用首次启动的动作
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let firstTime = userDefaults.boolForKey("FirstTime")
        if firstTime {
            
            let alertView = UIAlertView()
            alertView.addButtonWithTitle("好")
            alertView.title = "使用帮助"
            alertView.message = "加号添加计划类型\n\n小 i 编辑计划类型\n\n左滑删除计划类型\n\n点击进入详细计划\n\n开始有计划的一天\n\n使用愉快,么么哒\n\n(可以通过点击项目列表左上角的更多按钮获取帮助信息)"
            alertView.show()
            
            /*var checklist = Checklist(name: "+添加计划类型")
            lists.append(checklist)
            checklist = Checklist(name: "小i编辑计划类型")
            lists.append(checklist)
            checklist = Checklist(name: "左滑删除计划类型")
            lists.append(checklist)
            checklist = Checklist(name: "点击进入详细计划")
            lists.append(checklist)
            checklist = Checklist(name: "使用愉快,么么哒")
            lists.append(checklist)*/
            //indexOfSelectedChecklist = 0 //进入子页面
            userDefaults.setBool(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    
    func sortChecklists() {
        lists.sortInPlace({
            checklist1, checklist2 in
            return checklist1.name.localizedStandardCompare(checklist2.name) == .OrderedAscending
        })
    }
    
    
    var indexOfSelectedChecklist: Int {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey( "ChecklistIndex")
        }
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue,forKey: "ChecklistIndex")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    class func nextChecklistItemID() -> Int {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let itemID = userDefaults.integerForKey("ChecklistItemID")
        userDefaults.setInteger(itemID + 1, forKey: "ChecklistItemID")
        userDefaults.synchronize()
        return itemID
    }
}

