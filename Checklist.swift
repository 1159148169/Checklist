//
//  Checklist.swift
//  CheckListTest
//
//  Created by Shi Feng on 16/5/6.
//  Copyright © 2016年 Shi Feng. All rights reserved.
//

import UIKit

class Checklist: NSObject,NSCoding {
    var name = ""
    var items = [ChecklistItem]()
    var iconName: String
    
    convenience init(name: String) {
        self.init(name: name, iconName: "No Icon")
    }
    
    init(name: String,iconName: String) { //构造函数
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("Name") as! String
        items = aDecoder.decodeObjectForKey("Items") as! [ChecklistItem]
        iconName = aDecoder.decodeObjectForKey("IconName") as! String
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "Name")
        aCoder.encodeObject(items, forKey: "Items")
        aCoder.encodeObject(iconName, forKey: "IconName")
    }
    
    func countUncheckedItems() -> Int { //计算还差多少项目未完成
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
    }
}
