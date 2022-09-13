//
//  AppDelegate.swift
//  Face Detection
//
//  Created by Rafi Mochamad Fahreza on 25/08/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        #if targetEnvironment(simulator)
        window?.makeKeyAndVisible()
        window?.rootViewController = UIStoryboard(name: "SimulatorDetectedStoryboard", bundle: nil).instantiateInitialViewController()
        #else
        window?.makeKeyAndVisible()
        window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        #endif
        return true
    }

}

