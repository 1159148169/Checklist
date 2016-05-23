//
//  IconPickerViewController.swift
//  CheckListTest
//
//  Created by Shi Feng on 16/5/12.
//  Copyright © 2016年 Shi Feng. All rights reserved.
//

import UIKit


protocol IconPickerViewControllerDelegate: class {
    func iconPicker(picker: IconPickerViewController,didPickIcon iconName: String)
}


class IconPickerViewController: UITableViewController {
    weak var delegate: IconPickerViewControllerDelegate?
    
    let icons = [ "无图标",
                  "健身",
                  "学习",
                  "生活",
                  "办公",
                  "摄影",
                  "旅行" ] //图标定义为常量因为用户无法更改或删除图标
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None //去除cell之间的分割线
    }
    
    override func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("IconCell", forIndexPath: indexPath)
        let iconName = icons[indexPath.row]
        cell.textLabel!.text = iconName
        cell.imageView!.image = UIImage(named: iconName)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let delegate = delegate {
            let iconName = icons[indexPath.row]
            delegate.iconPicker(self, didPickIcon: iconName)
        }
    }
    
}
