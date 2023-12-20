//
//  PaywallVM.swift
//  TickerApp
//
//  Created by Serj on 19.10.2023.
//

import Foundation
import ApphudSDK

// MARK: - Model
struct PaywallDataModel {
    let imageName: String
    let title: String
    let subtitle: String
}

// MARK: - View Model
struct PaywallViewModel {
    
    let paywallDataArr: [PaywallDataModel]
    
    init() {
    
        self.paywallDataArr = [
            // 0
            PaywallDataModel(
                imageName: "Onboarding1.png",
                title: "Dynamic Information Showcase",
                subtitle: "Display important information, news or messages in real-time, ensuring your audience stays informed and engaged."
            ),
            // 1
            PaywallDataModel(
                imageName: "Onboarding2.png",
                title: "Your opinion is valuable to us",
                subtitle: "Please take a moment to rate our app. Your feedback helps us improve and create a better experience for you."
            ),
            // 2
            PaywallDataModel(
                imageName: "Onboarding3.png",
                title: "Endless ticker customization",
                subtitle: "Dive into a Spectrum of Colors, Elevate with Stunning Backgrounds, and Express Your Unique Style"
            ),
            // 3 Paywall
//            PaywallDataModel(
//                imageName: "Paywall_IMG.png",
//                title: "Get all the features you need",
//                subtitle: "Unlock all features with a subscription at just 4.99 $ per week, and enjoy a complimentary 3-day free trial!"
//            ),
            PaywallDataModel(
                imageName: "Paywall_IMG.png",
                title: "",
                subtitle: ""
            ),
        ]
    }
    
}



