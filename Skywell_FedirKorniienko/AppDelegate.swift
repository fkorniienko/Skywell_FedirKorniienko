//
//  AppDelegate.swift
//  Skywell_FedirKorniienko
//
//  Created by Fedir Korniienko on 02.06.17.
//  Copyright © 2017 fedir. All rights reserved.
//

import UIKit
import CoreData

enum AppStoryboard : String {
    
    case Main
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}

let mainStoryboard  = AppStoryboard.Main.instance

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Localization.doTheExchange()
        Localization.setLanguageTo(Localization.currentLanguage(forDevice: true))
        let alert = UIAlertController(title: NSLocalizedString("Choose your preferred language", comment: ""), message: "", preferredStyle: UIAlertControllerStyle.alert)


        alert.addAction(UIAlertAction(title: NSLocalizedString("English", comment: ""), style: UIAlertActionStyle.cancel,handler: {action in
            
            Localization.setLanguageTo("en_US")
            self.window?.rootViewController = mainStoryboard.instantiateViewController(withIdentifier: "main")


        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Русский", comment: ""), style: UIAlertActionStyle.default,handler: {action in
           Localization.setLanguageTo("ru_US")
            self.window?.rootViewController = mainStoryboard.instantiateViewController(withIdentifier: "main")


        }))
        
        DispatchQueue.main.async {
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.coreDataStack.saveContext()
    }




}

