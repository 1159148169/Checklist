//
//  CheckListViewController.swift
//  CheckListTest
//
//  Created by Shi Feng on 16/3/7.
//  Copyright © 2016年 Shi Feng. All rights reserved.
//

import UIKit

class CheckListViewController: UITableViewController,ItemDetailViewControllerDelegate {//这里视图控制器类继承了UITableViewController这个父类而非UIViewController 所以只需要在storyboard中设置datasource和delegate 不需要再代码里再设置
    
    var checklist:Checklist!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None //去除cell之间的分割线
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {//更改对勾点击状态(简化版)
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmarkForCell(cell, withChecklistItem: item) //更改对勾点击状态关键方法
    }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)//单元格点击后颜色还原(有动画)
    }
    
    func configureCheckmarkForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel //自定义对勾
        label.textColor = view.tintColor
        if item.checked {
            label.text = "√"
        }
        else {
            label.text = ""
        }
    }
    
    func configureTextForCell(cell: UITableViewCell,withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1 //返回组数
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return checklist.items.count //返回行数
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CheckListItem", forIndexPath: indexPath)
        let item = checklist.items[indexPath.row]
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
        configureTextForCell(cell, withChecklistItem: item)
        configureCheckmarkForCell(cell, withChecklistItem: item)
        return cell
    }
    
    //删除表格
    /*override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        checklist.items.removeAtIndex(indexPath.row) //删除数据
        
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
    }*/
    
    //实现下面的删除和重要功能下面这段必不可少
    override func tableView(tableView:UITableView,commitEditingStyle editingStyle:UITableViewCellEditingStyle,forRowAtIndexPath indexPath:NSIndexPath) {
    }
    
    //下面的代码实现扫动出现功能菜单
    override func tableView(tableView:UITableView,editActionsForRowAtIndexPath indexPath:NSIndexPath) ->[UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "删除", handler: {
            (action:UITableViewRowAction,indexPath:NSIndexPath) -> Void in
            
            self.checklist.items.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        })
        
        let importantAction = UITableViewRowAction(style: .Default, title: "重要", handler: {
            (action:UITableViewRowAction,indexPath:NSIndexPath) -> Void in

            let cell = tableView.cellForRowAtIndexPath(indexPath) //此行很重要 决定了cell是重新初始化还是使用现有的
            let label = cell!.viewWithTag(1000) as! UILabel
            
            label.textColor = UIColor.redColor()
            
        })
        
        let unImportantAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "不重要", handler: {
            (action:UITableViewRowAction,indexPath:NSIndexPath) -> Void in
            
            let cell = tableView.cellForRowAtIndexPath(indexPath) //此行很重要 决定了cell是重新初始化还是使用现有的
            let label = cell!.viewWithTag(1000) as! UILabel
            
            label.textColor = UIColor.blackColor()
            
        })
        
        importantAction.backgroundColor = view.tintColor
        unImportantAction.backgroundColor = view.tintColor
        
        return[deleteAction,unImportantAction,importantAction]
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
        }
        else if segue.identifier == "EditItem" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) { //协议中定义方法的实现
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) { //协议中定义方法的实现
        let newRowIndex = checklist.items.count //添加新的行的索引
        checklist.items.append(item)
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0) //表格视图使用索引识别新的行
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func itemDetailViewController(controller:ItemDetailViewController,didFinishEditingItem item:ChecklistItem) {
        if let index = checklist.items.indexOf(item) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                configureTextForCell(cell, withChecklistItem: item) }
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*@IBAction func addItem() {
        let newRowIndex = items.count //添加新的行的索引
        let item = ChecklistItem()
        item.text = "我是新的一行 瓜皮健"
        item.checked = false
        items.append(item)
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0) //表格视图使用索引识别新的行 现在的索引是newRowIndex 5
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
    }*/
}
