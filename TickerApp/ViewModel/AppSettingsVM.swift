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
    var settingsVC: SettingsVC? { get set }
}

class AppSettingsVM {
    // For remote open
    var delegateVC: SettingsVCDelegate? = nil
    
    var settingsCells: [AppSettingsCell] = []
    
    init() {
        configAppSettingsData()
    }
}

extension AppSettingsVM {
    // MARK: - config Effect Data
    private func configAppSettingsData() {
        // Empty
        settingsCells.append(
            AppSettingsCell(title: "", iconSystemName: "", handler: {
                // Empty cell!
            }))
        // MARK: - Rate us
        settingsCells.append(
            AppSettingsCell(title: "Rate us", iconSystemName: "star.fill", handler: {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegateVC?.settingsVC?.requestReview()
                }
            })
        )
        // MARK: - Privacy policy
        settingsCells.append(
            AppSettingsCell(title: "Privacy policy", iconSystemName: "exclamationmark.circle.fill", handler: {
                guard let url = URL(string: "https://ledbanner-privacy.web.app/") else { return }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    let safariVC = SFSafariViewController(url: url)
                    safariVC.modalPresentationStyle = .pageSheet
                    self.delegateVC?.settingsVC?.present(safariVC, animated: true)
                }
            })
        )
        // MARK: - Support
        settingsCells.append(
            AppSettingsCell(title: "Support", iconSystemName: "questionmark.circle.fill", handler: {
                let address = "vaheedarshaad@gmail.com"
                guard let url = URL(string: "mailto:\(address)") else { return }
                UIApplication.shared.open(url)
            })
        )
        // MARK: - Restore purshace
        settingsCells.append(
            AppSettingsCell(title: "Restore purshace", iconSystemName: "tag.fill", handler: {
                Task {
                    await Apphud.restorePurchases()
                }
            })
        )
        // MARK: - Share
        settingsCells.append(
            AppSettingsCell(title: "Share", iconSystemName: "arrowshape.turn.up.right.fill", handler: {
                self.shareButtonClicked()
            })
        )
        // MARK: - Delete history
        settingsCells.append(
            AppSettingsCell(title: "Delete history", iconSystemName: "trash.fill", handler: {
                // Delete All
                let realm = try? Realm()
                try? realm?.write {
                    realm?.deleteAll()
                }
            })
        )
    }
}

extension AppSettingsVM {
    func shareButtonClicked() {
       
       let textToShare = String(describing: "LED Banner App")
       guard
        let myAppURLToShare = URL(string: "https://apps.apple.com/app/the-led-banner-scroller/id6470816709"),
        let image = UIImage(named: "AppIcon.jpg")
        else { return }
       let items = [textToShare, myAppURLToShare, image] as [Any]
       let avc = UIActivityViewController(activityItems: items, applicationActivities: nil)

       //Apps to exclude sharing to
       avc.excludedActivityTypes = [
        UIActivity.ActivityType.airDrop,
        UIActivity.ActivityType.print,
        UIActivity.ActivityType.saveToCameraRoll,
        UIActivity.ActivityType.addToReadingList
       ]
       //Present the shareView on iPhone
        DispatchQueue.main.async(qos: .default) {
            // Презент с ошибкой
            self.delegateVC?.settingsVC?.present(avc, animated: true)
        }
    }
}
