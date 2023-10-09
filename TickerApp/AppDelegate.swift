//
//  AppDelegate.swift
//  TickerApp
//
//  Created by Serj on 30.09.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
//        let navVC = CustomNav(rootViewController: HomeVC())
//        window?.rootViewController = navVC
        
        
        window?.rootViewController = EditBannerVC()
//        window?.rootViewController = OnboardingVC()
        
        window?.makeKeyAndVisible()
        
        return true
    }
    
}
