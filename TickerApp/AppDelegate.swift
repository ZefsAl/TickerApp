//
//  AppDelegate.swift
//  TickerApp
//
//  Created by Serj on 30.09.2023.
//

import UIKit
import ApphudSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var window: UIWindow?
    var observer: NSKeyValueObservation?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // MARK: - Test
//        AppDelegate.window = UIWindow(frame: UIScreen.main.bounds)
//        let homeNavVC = UINavigationController(rootViewController: EditBannerVC(tickerDataModel: nil))
//        AppDelegate.window?.rootViewController = homeNavVC
//        AppDelegate.window?.makeKeyAndVisible()
        // MARK: - Test
//        UserDefaults.standard.setValue(false, forKey: "OnboardingCompletedKey")
//        UserDefaults.standard.synchronize()
        
        updateRootVC()
        setupApphud()
        return true
    }
    
    // Orientation
    var defaultOrientation: UIInterfaceOrientationMask = .portrait
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        defaultOrientation
    }
}

// MARK: - setup Apphud
extension AppDelegate {
    private func setupApphud() {
        Apphud.start(apiKey: "app_44b9qHFjkvuYQQc43pzwPLGwbaRBEX")
    }
}

// MARK: - Distribute Screen
extension AppDelegate {
     
    func updateRootVC() {
        observer = UserDefaults.standard.observe(\.onboardingIsCompleted, options: [.initial, .new], changeHandler: { (defaults, change) in

            print("Observe - onboardingIsCompleted: \(defaults.onboardingIsCompleted)")
            if defaults.onboardingIsCompleted == true {
                
                AppDelegate.window = UIWindow(frame: UIScreen.main.bounds)
                let homeNavVC = CustomNav(rootViewController: HomeVC())
                AppDelegate.window?.rootViewController = homeNavVC
                AppDelegate.window?.makeKeyAndVisible()
            } else {
                AppDelegate.window = UIWindow(frame: UIScreen.main.bounds)
                AppDelegate.window?.rootViewController = PaywallVC()
                AppDelegate.window?.makeKeyAndVisible()
            }
        })
    }
}

