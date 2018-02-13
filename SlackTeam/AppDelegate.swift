    //
//  AppDelegate.swift
//  SlackTeam
//
//  Created by Nicholas Long on 2/9/18.
//  Copyright © 2018 Nicholas Long. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.barTintColor = UIColor.slackPurp()
        
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        splitViewController.delegate = self
        splitViewController.preferredDisplayMode = .allVisible
        
        UIApplication.shared.statusBarStyle = .lightContent
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        CoreDataContextCoordinator.shared.mainQueueContext.saveOrRollback()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataContextCoordinator.shared.mainQueueContext.saveOrRollback()
    }
}

extension AppDelegate: UISplitViewControllerDelegate {

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? UserViewController else { return false }
        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            //
            return true
        }
        return false
    }
}

