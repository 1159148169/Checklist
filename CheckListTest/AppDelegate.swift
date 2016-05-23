//
//  AppDelegate.swift
//  CheckListTest
//
//  Created by Shi Feng on 16/3/7.
//  Copyright © 2016年 Shi Feng. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,WXApiDelegate {

    var window: UIWindow?
    
    let dataModel = DataModel()
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        WXApi.registerApp("wx840b6b9e34e05c4e") //注册app
        
        let navigationController = window!.rootViewController as! UINavigationController
        let controller = navigationController.viewControllers[0] as! AllListsViewController
        controller.dataModel = dataModel
        
        //发送本地通知示例
        /*let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert,.Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        let date = NSDate(timeIntervalSinceNow: 10) //消息会在应用启动10秒后进行通知
        let localNotification = UILocalNotification()
        localNotification.fireDate = date
        localNotification.timeZone = NSTimeZone.defaultTimeZone() //时区
        localNotification.alertBody = "我是一个通知" //通知信息
        localNotification.soundName = UILocalNotificationDefaultSoundName //通知声音
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)*/
        
        // Override point for customization after application launch.
        
        //添加icon 3d Touch
        let firstItemIcon:UIApplicationShortcutIcon = UIApplicationShortcutIcon(type: UIApplicationShortcutIconType.Share)
        let firstItem = UIMutableApplicationShortcutItem(type: "1", localizedTitle: "更多", localizedSubtitle: nil, icon: firstItemIcon, userInfo: nil)
        
        let firstItemIcon1:UIApplicationShortcutIcon = UIApplicationShortcutIcon(type: UIApplicationShortcutIconType.Bookmark)
        let firstItem1 = UIMutableApplicationShortcutItem(type: "2", localizedTitle: "查看任务", localizedSubtitle: nil, icon: firstItemIcon1, userInfo: nil)
        
        let firstItemIcon2:UIApplicationShortcutIcon = UIApplicationShortcutIcon(type: UIApplicationShortcutIconType.Add)
        let firstItem2 = UIMutableApplicationShortcutItem(type: "3", localizedTitle: "新建任务类型", localizedSubtitle: nil, icon: firstItemIcon2, userInfo: nil)
        
        application.shortcutItems = [firstItem,firstItem1,firstItem2]
        
        return true
    }
    
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        
        let handledShortCutItem = handleShortCutItem(shortcutItem)
        completionHandler(handledShortCutItem)
        
    }
    
    func handleShortCutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
        
        var handled = false
        
        if shortcutItem.type == "1" { //更多
            
            let rootNavigationViewController = window!.rootViewController as? UINavigationController
            let rootViewController = rootNavigationViewController?.viewControllers.first as! AllListsViewController
            
            rootNavigationViewController?.popToRootViewControllerAnimated(false)
            rootViewController.performSegueWithIdentifier("ShowMore", sender: nil)
            handled = true
        }
        
        else if shortcutItem.type == "2" { //查看
            
            let rootNavigationViewController = window!.rootViewController as? UINavigationController
            
            rootNavigationViewController?.popToRootViewControllerAnimated(false)
            
            handled = true
            
        }
        
        else if shortcutItem.type == "3" { //增加任务类型
            
            handled = true
        }
        
        return handled
    }
    
    func saveData() {
        dataModel.saveChecklists()
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        
        saveData()
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        saveData()
        
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject])
        -> Bool {
            return TencentOAuth.HandleOpenURL(url)
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        let string: String = url.absoluteString
        if string.hasPrefix("wx840b6b9e34e05c4e") {
            return WXApi.handleOpenURL(url, delegate: self)
        }
        else {
            return TencentOAuth.HandleOpenURL(url)
        }
    }
    
    func onReq(req: BaseReq!) {
        //onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
    }
    func onResp(resp: BaseResp!) {
        //如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
    }

}

