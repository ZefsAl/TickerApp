//
//  OnboardingVC.swift
//  TickerApp
//
//  Created by Serj on 08.10.2023.
//

import UIKit
import ApphudSDK

final class OnboardingVC: UIViewController {
    
    // MARK: - ctaButton
    private let ctaButton: BigButton = {
        let b = BigButton(
            frame: .zero,
            bgColor: AppColors.primary,
            title: "Continue",
            titleColor: AppColors.secondary,
            iconSystemName: nil,
            iconColor: nil
        )
        b.icon.isHidden = true
        return b
    }()
    
    private let promoImage: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleToFill
//        iv.backgroundColor = .systemOrange
        iv.image = UIImage(named: "Paywall_IMG.png")
        
        return iv
    }()
    
    // MARK: Promo Title
    private let promoTitle: UILabel = {
        let l = UILabel()
        l.textColor = .white
        l.numberOfLines = 1
//        var paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineHeightMultiple = 1.04
        
        let text = "Get all the features you need"
        l.text = text
//        l.attributedText = NSMutableAttributedString(string: text,attributes: [NSAttributedString.Key.kern: -0.8, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        l.font = SFProRounded.set(fontSize: 26, weight: .semibold)
        l.textAlignment = .center
        return l
    }()
    
    // MARK: Subtitle
    private let subtitle: UILabel = {
        let l = UILabel()
        l.textColor = AppColors.gray1
        l.numberOfLines = 3
        l.textAlignment = .center
//        var paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineHeightMultiple = 1.04
        
        let text = "Unlock all features with a subscription at just $4.99 per week, and enjoy a complimentary 3-day free trial!"
        l.text = text
//        l.attributedText = NSMutableAttributedString(string: title,attributes: [NSAttributedString.Key.kern: -0.8, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        l.font = SFProRounded.set(fontSize: 17, weight: .semibold)
        return l
    }()
    
    // MARK: - Terms Button
    private let termsButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Terms Of Use", for: .normal)
        b.titleLabel?.font = SFProRounded.set(fontSize: 13, weight: .bold)
        b.setTitleColor(AppColors.gray2, for: .normal)
        
        b.addTarget(Any?.self, action: #selector(termsOfUseAct), for: .touchUpInside)
        return b
    }()
    @objc private func termsOfUseAct() {
        print("termsOfUseAct")
        
//        guard let url = URL(string: "https://numerology-terms.web.app/") else { return }
        
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            let safariVC = SFSafariViewController(url: url)
//            safariVC.modalPresentationStyle = .pageSheet
//            self.present(safariVC, animated: true)
//        }
    }
    
    // MARK: - Privacy Button
    private let privacyButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Privacy Policy", for: .normal)
        b.titleLabel?.font = SFProRounded.set(fontSize: 13, weight: .bold)
        b.setTitleColor(AppColors.gray2, for: .normal)
        
        b.addTarget(Any?.self, action: #selector(privacyPolicyAct), for: .touchUpInside)
        return b
    }()
    @objc private func privacyPolicyAct() {
//        guard let url = URL(string: "https://numerology-privacy.web.app/") else { return }
        
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            let safariVC = SFSafariViewController(url: url)
//            safariVC.modalPresentationStyle = .pageSheet
//            self.present(safariVC, animated: true)
//        }
    }
    
    // MARK: - Restore Button
    private let restoreButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Restore purchases", for: .normal)
        
        b.titleLabel?.font = SFProRounded.set(fontSize: 13, weight: .bold)
        b.setTitleColor(AppColors.gray2, for: .normal)
        
        b.addTarget(Any?.self, action: #selector(restoreAct), for: .touchUpInside)
        return b
    }()
    @objc private func restoreAct() {
        print("Restore purchases")
        
//        Purchases.shared.restorePurchases { (customerInfo, error) in
//            // проверить есть ли подписка -> Предоставить доступ
//            if customerInfo?.entitlements.all["Access"]?.isActive == true {
//                print("User restored!")
//                //                self.dismiss(animated: true)
//            } else {
//                print("User not restored")
//            }
//        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - view Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setSettingNavButtonItem(selectorStr: #selector(self.settingsAct))
        setupVCStyle()
        setupUI()
    }
    
    private func setNavStyle() {
//        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backgroundColor = .clear
    }
    
    // MARK: - Actions
    @objc func settingsAct() {
        print("ettingsAct")
    }
    
    
    
}



extension OnboardingVC {
    
    // MARK: - Style
    private func setupVCStyle() {
        self.view.backgroundColor = .black
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        
        
        // Docs Stack
        let docsStack = UIStackView(arrangedSubviews: [termsButton,restoreButton,privacyButton])
        docsStack.axis = .horizontal
        docsStack.spacing = 0
        docsStack.distribution = .fillEqually

        
        
        
        // button stack
        let buttonStack = UIStackView(arrangedSubviews: [ctaButton,docsStack])
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.axis = .vertical
        buttonStack.alignment = .fill
        buttonStack.spacing = 16
        buttonStack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        buttonStack.isLayoutMarginsRelativeArrangement = true
        
        
        // Text Stack
        let textStack = UIStackView(arrangedSubviews: [promoTitle,subtitle])
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.axis = .vertical
        textStack.alignment = .fill
        textStack.spacing = 8
        textStack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        textStack.isLayoutMarginsRelativeArrangement = true
        
        

        
        // Content Stack
        let contentStack = UIStackView(arrangedSubviews: [promoImage,textStack,buttonStack])
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.alignment = .fill
        contentStack.distribution = .equalSpacing
//        contentStack.spacing = 0
        
        
        
        
        
        // Subview
        self.view.addSubview(contentStack)
        
        // Margin
        let viewMargin = self.view.layoutMarginsGuide
        // Stack values
//        let left: CGFloat = 16
//        let right: CGFloat = -16
//        let width: CGFloat = right - left
        
        
        NSLayoutConstraint.activate([
            
            promoImage.heightAnchor.constraint(lessThanOrEqualToConstant: 487),
            
            contentStack.topAnchor.constraint(equalTo: viewMargin.topAnchor, constant: 0),
            contentStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            contentStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            contentStack.bottomAnchor.constraint(equalTo: viewMargin.bottomAnchor, constant: -0),
            
            
            
        ])
    }
    
    
    
}
