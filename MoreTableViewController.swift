//
//  MoreTableViewController.swift
//  CheckListTest
//
//  Created by Shi Feng on 16/5/19.
//  Copyright © 2016年 Shi Feng. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController {
    
    var _tencentOAuth:TencentOAuth!
    
    var _scene = Int32(WXSceneTimeline.rawValue) //发送给好友还是朋友圈(默认朋友圈)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _tencentOAuth = TencentOAuth.init(appId: "1105415582", andDelegate: nil)
    }

    @IBAction func share() {
        let menu = UIAlertController(title: "分享每日计划 让更多人的生活更有规律", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        //qq分享
        let qqFriendAction = UIAlertAction(title: "QQ好友", style: UIAlertActionStyle.Default) {
            (action) -> Void in
            let txtObj = QQApiTextObject(text: "每日计划,让生活更有规律!")
            let req = SendMessageToQQReq(content: txtObj)
            QQApiInterface.sendReq(req)
        }
        
        menu.addAction(qqFriendAction)
        
        //qq空间分享
        let qzoneAction = UIAlertAction(title: "QQ空间", style: UIAlertActionStyle.Default) {
            （action）-> Void in
            let newsUrl = NSURL(string: "http://weibo.com/u/1999818521")
            let title = "让你的生活从此更加规律"
            let description = "每日计划,一个可以改变自己的APP!"
            let previewImageUrl = NSURL(string: "http://cdn.duitang.com/uploads/item/201510/02/20151002201912_Yw2sU.thumb.224_0.jpeg")
            let newsObj = QQApiNewsObject(URL: newsUrl, title: title, description: description,
                                          previewImageURL: previewImageUrl, targetContentType: QQApiURLTargetTypeNews)
            let req = SendMessageToQQReq(content: newsObj)
            QQApiInterface.SendReqToQZone(req)
        }
        
        menu.addAction(qzoneAction)
        
        //微信朋友圈分享(链接分享)
        let weichatAction = UIAlertAction(title: "朋友圈", style: UIAlertActionStyle.Default) {
            (action) -> Void in
            let message =  WXMediaMessage()
            
            
            message.title = "每日计划,一个可以改变自己的APP!"
            message.description = "通过计划,让你每天的生活更加规律!"
            message.setThumbImage(UIImage(named:"微信分享图.png"))
            
            
            let ext =  WXWebpageObject()
            ext.webpageUrl = "http://weibo.com/u/1999818521"
            message.mediaObject = ext
            
            
            let req =  SendMessageToWXReq()
            req.bText = false
            req.message = message
            req.scene = self._scene
            WXApi.sendReq(req)
        }
        
        menu.addAction(weichatAction)
        
        let cancelAction = UIAlertAction(title: "关闭", style: UIAlertActionStyle.Cancel, handler: nil)
        
        menu.addAction(cancelAction)
        
        self.presentViewController(menu,animated:true,completion:nil)
    }
    
    @IBAction func help() {
        let alertView = UIAlertView()
        alertView.addButtonWithTitle("好")
        alertView.title = "使用帮助"
        alertView.message = "加号添加计划类型\n\n小 i 编辑计划类型\n\n左滑删除计划类型\n\n点击进入详细计划\n\n开始有计划的一天\n\n使用愉快,么么哒"
        alertView.show()
    }
    
    @IBAction func connect() {
        let alertController = UIAlertController(title: "哈喽", message: "我是石峰\n这是我的qq\n1159148169\n有任何问题欢迎反馈给我\n(づ￣ 3￣)づ", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "好", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController,animated: true,completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)//单元格点击后颜色还原(有动画)
    }
    
}
