//
//  ListDetailViewController.swift
//  CheckListTest
//
//  Created by Shi Feng on 16/5/7.
//  Copyright © 2016年 Shi Feng. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: class { //实现协议
    func listDetailViewControllerDidCancel(controller:ListDetailViewController)
    func listDetailViewController(controller:ListDetailViewController,didFinishAddingChecklist checklist:Checklist) //增加项目代理
    func listDetailViewController(controller:ListDetailViewController,didFinishEditingChecklist checklist:Checklist) //编辑项目代理
}

class ListDetailViewController: UITableViewController,UITextFieldDelegate,IconPickerViewControllerDelegate {
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var iconImageView:UIImageView!
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    var checklistToEdit: Checklist?
    
    var iconName = "无图标"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let checklist = checklistToEdit {
            title = "编辑计划类型"
            textField.text = checklist.name
            doneBarButton.enabled = true
            iconName = checklist.iconName
        }
        iconImageView.image = UIImage(named: iconName)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 1 {
            return indexPath
        }
        else {
            return nil
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PickIcon" {
            let controller = segue.destinationViewController as! IconPickerViewController
            controller.delegate = self
        }
    }
    
    @IBAction func cancleButton() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func doneButton() {
        if let checklist = checklistToEdit {
            checklist.name = textField.text!
            checklist.iconName = iconName
            delegate?.listDetailViewController(self, didFinishEditingChecklist: checklist)
        }
        else {
            let checklist = Checklist(name:textField.text!,iconName:iconName)
            delegate?.listDetailViewController(self, didFinishAddingChecklist: checklist)
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,replacementString string: String) -> Bool {
        let oldText: NSString = textField.text!
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        doneBarButton.enabled = (newText.length > 0)
        return true
    }
    
    func iconPicker(picker: IconPickerViewController, didPickIcon iconName: String) {
        self.iconName = iconName
        iconImageView.image = UIImage(named: iconName)
        navigationController?.popViewControllerAnimated(true) //不使用dismissViewController()这个方法
    }
}