//
//  AppSettingsVM.swift
//  TickerApp
//
//  Created by Serj on 22.10.2023.
//

import Foundation
import UIKit
import StoreKit
import ApphudSDK
import SafariServices
import RealmSwift

protocol SettingsVCDelegate {
    var viewController: SettingsVC? { get set }
}

class AppSettingsVM {
    // For remote open
    var delegateVC: SettingsVCDelegate? = nil
    
    var settingsCells: [AppSettingsCell] = []
    
    init() {
        configEffectData()
    }
}

extension AppSettingsVM {
    private func configEffectData() {
        settingsCells.append(
            AppSettingsCell(title: "", iconSystemName: "", handler: {
                // Empty cell!
            }))
        settingsCells.append(
            AppSettingsCell(title: "Rate us", iconSystemName: "star.fill", handler: {
                Task { 
                    guard let window = await AppDelegate.window?.windowScene else { return }
                    await SKStoreReviewController.requestReview(in: window)
                }
            }))
        settingsCells.append(
            AppSettingsCell(title: "Privacy policy", iconSystemName: "exclamationmark.circle.fill", handler: {
                guard let url = URL(string: "https://www.google.com") else { return }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    let safariVC = SFSafariViewController(url: url)
                    safariVC.modalPresentationStyle = .pageSheet
                    self.delegateVC?.viewController?.present(safariVC, animated: true)
                }
            }))
        settingsCells.append(
            AppSettingsCell(title: "Support", iconSystemName: "questionmark.circle.fill", handler: {
                
                guard let url = URL(string: "https://www.google.com") else { return }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    let safariVC = SFSafariViewController(url: url)
                    safariVC.modalPresentationStyle = .pageSheet
                    self.delegateVC?.viewController?.present(safariVC, animated: true)
                }
            }))
        settingsCells.append(
            AppSettingsCell(title: "Restore purshace", iconSystemName: "tag.fill", handler: {
                Task {
                    await Apphud.restorePurchases()
                }
            }))
        settingsCells.append(
            AppSettingsCell(title: "Share", iconSystemName: "arrowshape.turn.up.right.fill", handler: {
                DispatchQueue.main.async {
                    // Будет презент с ошибкой
                    self.shareButtonClicked()
                }
                
            }))
        settingsCells.append(
            AppSettingsCell(title: "Delete history", iconSystemName: "clock.fill", handler: {
                // Delete All
                let realm = try? Realm()
                try? realm?.write {
                    realm?.deleteAll()
                }
            }))
    }
}

extension AppSettingsVM {
    func shareButtonClicked() {
       
       let textToShare = String(describing: "My awesome app")
       guard
        let myAppURLToShare = URL(string: "https://apps.apple.com/app/id6446824311"),
        let image = UIImage(named: "AppIcon.jpg")
        else {
           return
       }
       let items = [textToShare, myAppURLToShare, image] as [Any]
       let avc = UIActivityViewController(activityItems: items, applicationActivities: nil)

       //Apps to exclude sharing to
       avc.excludedActivityTypes = [
        UIActivity.ActivityType.airDrop,
        UIActivity.ActivityType.print,
        UIActivity.ActivityType.saveToCameraRoll,
        UIActivity.ActivityType.addToReadingList
       ]
       //If user on iPad
//       if UIDevice.current.userInterfaceIdiom == .pad {
//           if avc.responds(to: #selector(getter: UIViewController.popoverPresentationController)) {
//               avc.popoverPresentationController?.barButtonItem = sender
//           }
//       }
       //Present the shareView on iPhone
        self.delegateVC?.viewController?.present(avc, animated: true)
    }
}
