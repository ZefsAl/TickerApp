//
//  ApphudInternal+Eligibility.swift
//  apphud
//
//  Created by Renat on 01.07.2020.
//  Copyright © 2020 Apphud Inc. All rights reserved.
//

import Foundation
import StoreKit

extension ApphudInternal {

    // MARK: - Eligibilities API

    internal func checkEligibilitiesForPromotionalOffers(products: [SKProduct], callback: @escaping ApphudEligibilityCallback) {

        let result = performWhenUserRegistered {

            apphudLog("User registered, check promo eligibility")

            let didSendReceiptForPromoEligibility = "ReceiptForPromoSent"

            // not found subscriptions, try to restore and try again
            if self.currentUser?.subscriptions.count ?? 0 == 0 && !UserDefaults.standard.bool(forKey: didSendReceiptForPromoEligibility) {
                if let receiptString = apphudReceiptDataString() {
                    apphudLog("Restoring subscriptions for promo eligibility check")
                    self.submitReceipt(product: nil, apphudProduct: nil, transaction: nil, receiptString: receiptString, notifyDelegate: true, eligibilityCheck: true, callback: { _ in
                        UserDefaults.standard.set(true, forKey: didSendReceiptForPromoEligibility)
                        self._checkPromoEligibilitiesForRegisteredUser(products: products, callback: callback)
                    })
                } else {
                    apphudLog("Receipt not found on device, impossible to determine eligibility. This is probably missing sandbox receipt issue. This should never not happen on production, because there receipt always exists. For more information see: https://docs.apphud.com/docs/testing-troubleshooting. Exiting", forceDisplay: true)
                    var response = [String: Bool]()
                    for product in products {
                        response[product.productIdentifier] = false // cannot purchase offer by default
                    }
                    callback(response)
                }
            } else {
                apphudLog("Has purchased subscriptions or has checked receipt for promo eligibility")
                self._checkPromoEligibilitiesForRegisteredUser(products: products, callback: callback)
            }
        }
        if !result {
            apphudLog("Tried to check promo eligibility, but user not registered, adding to schedule")
        }
    }

    private func _checkPromoEligibilitiesForRegisteredUser(products: [SKProduct], callback: @escaping ApphudEligibilityCallback) {

        var response = [String: Bool]()
        for product in products {
            response[product.productIdentifier] = false
        }

        let result = self.performWhenProductGroupsFetched {

            apphudLog("Products fetched, check promo eligibility")

            for subscription in self.currentUser?.subscriptions ?? [] {
                for product in products {
                    let purchasedGroupId = self.groupID(productId: subscription.productId)
                    let givenGroupId = self.groupID(productId: product.productIdentifier)
                    if (subscription.productId == product.productIdentifier) ||
                        (purchasedGroupId != nil && purchasedGroupId == givenGroupId) {
                        // if the same product id or in the same apphud product group
                        response[product.productIdentifier] = true
                        // do not break, check all products
                    }
                }
            }
            apphudLog("Finished promo checking, response: \(response as AnyObject)")
            callback(response)
        }
        if !result {
            apphudLog("Tried to check promo eligibility, but products not fetched, adding to schedule")
        }
    }

    /// Checks introductory offers eligibility (includes free trial, pay as you go or pay up front)
    internal func checkEligibilitiesForIntroductoryOffers(products: [SKProduct], callback: @escaping ApphudEligibilityCallback) {

        let result = performWhenUserRegistered {

            apphudLog("User registered, check intro eligibility")

            // not found subscriptions, try to restore and try again

            let didSendReceiptForIntroEligibility = "ReceiptForIntroSent"

            if self.currentUser?.subscriptions.count ?? 0 == 0 && !UserDefaults.standard.bool(forKey: didSendReceiptForIntroEligibility) {
                if let receiptString = apphudReceiptDataString() {
                    apphudLog("Restoring subscriptions for intro eligibility check")
                    self.submitReceipt(product: nil, apphudProduct: nil, transaction: nil, receiptString: receiptString, notifyDelegate: true, eligibilityCheck: true, callback: { _ in
                        UserDefaults.standard.set(true, forKey: didSendReceiptForIntroEligibility)
                        self._checkIntroEligibilitiesForRegisteredUser(products: products, callback: callback)
                    })
                } else {
                    apphudLog("Receipt not found on device, impossible to determine eligibility. This is probably missing sandbox receipt issue. This should never not happen on production, because there receipt always exists. For more information see: https://docs.apphud.com/docs/testing-troubleshooting. Exiting", forceDisplay: true)
                    var response = [String: Bool]()
                    for product in products {
                        response[product.productIdentifier] = true // can purchase intro by default
                    }
                    callback(response)
                }
            } else {
                apphudLog("Has purchased subscriptions or has checked receipt for intro eligibility")
                self._checkIntroEligibilitiesForRegisteredUser(products: products, callback: callback)
            }
        }
        if !result {
            apphudLog("Tried to check intro eligibility, but user not registered, adding to schedule")
        }
    }

    private func _checkIntroEligibilitiesForRegisteredUser(products: [SKProduct], callback: @escaping ApphudEligibilityCallback) {

        var response = [String: Bool]()
        for product in products {
            response[product.productIdentifier] = true
        }

        let result = self.performWhenProductGroupsFetched {

            apphudLog("Products fetched, check intro eligibility")

            for subscription in self.currentUser?.subscriptions ?? [] {
                for product in products {
                    let purchasedGroupId = self.groupID(productId: subscription.productId)
                    let givenGroupId = self.groupID(productId: product.productIdentifier)

                    if subscription.productId == product.productIdentifier ||
                        (purchasedGroupId == givenGroupId && givenGroupId != nil) {
                        // if purchased, then this subscription is eligible for intro only if not used intro and status expired
                        let eligible = !subscription.isIntroductoryActivated && subscription.status == .expired
                        response[product.productIdentifier] = eligible
                        // do not break, check all products
                    }
                }
            }
            apphudLog("Finished intro checking, response: \(response as AnyObject)")
            callback(response)
        }

        if !result {
            apphudLog("Tried to check intro eligibility, but products not fetched, adding to schedule")
        }
    }
}
