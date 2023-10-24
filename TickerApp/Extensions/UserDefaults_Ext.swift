//
//  UserDefaults_Ext.swift
//  TickerApp
//
//  Created by Serj on 21.10.2023.
//

import Foundation


extension UserDefaults {
    
//    func setUserData(name: String, surname: String) {
//        setValue(name, forKey: "nameKey")
//        setValue(surname, forKey: "surnameKey")
//        synchronize()
//    }
    
    @objc dynamic var onboardingIsCompleted: Bool {
        return bool(forKey: "OnboardingCompletedKey")
    }
    
    // kvo
//    @objc dynamic var userAccess: Bool {
//        return bool(forKey: "UserAccessObserverKey")
//    }
    
}
