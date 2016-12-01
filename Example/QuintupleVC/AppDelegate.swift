//
//  AppDelegate.swift
//  QuintupleVC
//
//  Created by Zaid Pathan on 12/01/2016.
//  Copyright (c) 2016 Zaid Pathan. All rights reserved.
//

import UIKit
import QuintupleVC

fileprivate enum VCType:String{
    case centerVC = "CenterVC"
    case rightVC = "RightVC"
    case topVC = "TopVC"
    case leftVC = "LeftVC"
    case bottomVC = "BottomVC"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var quintupleVC:QuintupleVC?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupQuintupleVC()
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    fileprivate func setupQuintupleVC(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let centerVC = storyBoard.instantiateViewController(withIdentifier: VCType.centerVC.rawValue)
        let rightVC = storyBoard.instantiateViewController(withIdentifier: VCType.rightVC.rawValue)
        let topVC = storyBoard.instantiateViewController(withIdentifier: VCType.topVC.rawValue)
        let leftVC = storyBoard.instantiateViewController(withIdentifier: VCType.leftVC.rawValue)
        let bottomVC = storyBoard.instantiateViewController(withIdentifier: VCType.bottomVC.rawValue)

        
        quintupleVC = QuintupleVC(withCenterVC: centerVC, rightVC: rightVC, topVC: topVC, leftVC: leftVC, bottomVC: bottomVC)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.frame = UIScreen.main.bounds
        window?.rootViewController = quintupleVC
        window?.makeKeyAndVisible()
    }

}

