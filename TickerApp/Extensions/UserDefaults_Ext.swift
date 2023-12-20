//
//  UserDefaults_Ext.swift
//  TickerApp
//
//  Created by Serj on 21.10.2023.
//

import Foundation


extension UserDefaults {
    
    @objc dynamic var onboardingIsCompleted: Bool {
        return bool(forKey: "OnboardingCompletedKey")
    }
    
    // kvo
    @objc dynamic var userIsPremium: Bool {
        return bool(forKey: "UserIsPremiumObserverKey")
    }
    
}
