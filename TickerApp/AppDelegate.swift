//
//  AppDelegate.swift
//  TickerApp
//
//  Created by Serj on 30.09.2023.
//

import UIKit
import ApphudSDK
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var window: UIWindow?
    private var onboardingObserver: NSKeyValueObservation?
    
    private func checkTest() {
        //        AppDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        //        let homeNavVC = UINavigationController(rootViewController: PaywallVC())
        //        AppDelegate.window?.rootViewController = homeNavVC
        //        AppDelegate.window?.makeKeyAndVisible()
                // MARK: - Check
        //        UserDefaults.standard.setValue(false, forKey: "OnboardingCompletedKey")
        //        UserDefaults.standard.synchronize()
    }
    
    // MARK: - Finish
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // MARK: - Check
//        checkTest()
        
        
        // Setup
        migrateRealm()
        updateRootVC()
        setupApphud()
        registerFonts()
        checkActiveSubscription()
        return true
    }
    
    // MARK: - Register Font
    private func registerFonts() {
        let fonts = Bundle.main.urls(forResourcesWithExtension: "ttf", subdirectory: nil)
        fonts?.forEach({ url in
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        })
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
        onboardingObserver = UserDefaults.standard.observe(\.onboardingIsCompleted, options: [.initial, .new], changeHandler: { (defaults, change) in

            print("🔵 Observe - onboardingIsCompleted: \(defaults.onboardingIsCompleted)")
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




// MARK: - Orientation
class OrientationManager {
    static var orientation: UIInterfaceOrientationMask = .portrait
}
extension AppDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return OrientationManager.orientation
    }
}




extension AppDelegate {
    
    // MARK: - Realm migration
    private func migrateRealm() {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: 5)
    }
    
    
    
    
    // MARK: - check Active Subscription
    private func checkActiveSubscription() {
        // Hide premium badge
        let isActiveSubscription = Apphud.hasActiveSubscription()
        UserDefaults.standard.setValue(isActiveSubscription, forKey: "UserIsPremiumObserverKey")
        UserDefaults.standard.synchronize()
        
        if Apphud.hasActiveSubscription() {
            print("Have ✅ Apphud 💰", isActiveSubscription)
        } else {
            print("No ❌ Apphud 💰", isActiveSubscription)
        }
        
        print("UserDefaults 💰", UserDefaults.standard.object(forKey: "UserIsPremiumObserverKey") as? Bool)
        
        
        
//        userIsPremiumObserver = UserDefaults.standard.observe(\.userIsPremium, options: [.initial, .new], changeHandler: { (defaults, change) in
//
//            print("Defaults value : \(defaults.userIsPremium)")
//            if defaults.userIsPremium == true {
//                print("IsPremium ")
//            } else {
//            }
//        })
    }
}
