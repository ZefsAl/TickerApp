//
//  OnboardingVC.swift
//  TickerApp
//
//  Created by Serj on 08.10.2023.
//

import UIKit
import ApphudSDK
import StoreKit

final class PaywallVC: UIViewController {
    
    var observer: NSKeyValueObservation?
    var apphudProduct: ApphudProduct?
    
    var currentPageIndex = 0 {
        didSet {
            print(currentPageIndex)
            if currentPageIndex > 4 {
                currentPageIndex = 4
            }
        }
    }
    
    
    let docsStack = UIStackView(arrangedSubviews: [])
    
    
    // MARK: - continueBtn
    private let continueBtn: BigButton = {
        let b = BigButton(
            frame: .zero,
            bgColor: AppColors.primary,
            title: "Continue",
            titleColor: AppColors.secondary,
            iconSystemName: nil,
            iconColor: nil
        )
        b.icon.isHidden = true
        b.addTarget(Any?.self, action: #selector(nextAct), for: .touchUpInside)
        return b
    }()
    // MARK: - nextAct
    @objc private func nextAct(_ sender: BigButton) {
        
        let onboarding = UserDefaults.standard.object(forKey: "OnboardingCompletedKey") as? Bool
        guard let product = self.apphudProduct else { return }
        
        guard onboarding == false || onboarding == nil else {
            makePurchase(product: product)
            return
        }
        
        
        // ✅
        currentPageIndex += 1
        
        if currentPageIndex == 2 {
            Task {
                DispatchQueue.main.async {
                    guard let window = AppDelegate.window?.windowScene else { return }
                    SKStoreReviewController.requestReview(in: window)
                }
            }
        }
            
        
        guard currentPageIndex >= 3 else { configureOnboarding(isCompleted: false); return }
        // UI Config
        configureOnboarding(isCompleted: true)
        // End onboarding
        UserDefaults.standard.setValue(true, forKey: "OnboardingCompletedKey")
        UserDefaults.standard.synchronize()
        // Only - Purchase
        guard
            currentPageIndex == 4
        else { return }
        makePurchase(product: product)
        
    }
    
    
    // MARK: - Promo Image
    private let promoImage: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleToFill
//        iv.image = UIImage(named: "")
        return iv
    }()
    
    // MARK: Promo Title
    private let promoTitle: UILabel = {
        let l = UILabel()
        l.textColor = .white
        l.numberOfLines = 1
        
//        let text = "Get all the features you need"
//        l.text = text
        
        //        var paragraphStyle = NSMutableParagraphStyle()
        //        paragraphStyle.lineHeightMultiple = 1.04
//        l.attributedText = NSMutableAttributedString(string: text,attributes: [NSAttributedString.Key.kern: -0.8, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        l.font = SFProRounded.set(fontSize: 26, weight: .semibold)
        l.adjustsFontSizeToFitWidth = true
        l.textAlignment = .center
        return l
    }()
    
    // MARK: Subtitle
    private let subtitle: UILabel = {
        let l = UILabel()
        l.textColor = AppColors.gray1
        l.numberOfLines = 3
        l.textAlignment = .center
        l.lineBreakMode = .byClipping
        l.font = SFProRounded.set(fontSize: 17, weight: .regular)
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
    
    // MARK: - closeButton
    private let closeButton: UIButton = {
        
        let b = UIButton() // customView: type
        b.translatesAutoresizingMaskIntoConstraints = false
        
        let configImage = UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)) // 25~30x30-frame
        
        let iv = UIImageView(image: configImage)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = AppColors.gray2
        iv.isUserInteractionEnabled = false
//            iv.contentMode = .scaleAspectFit //
        
        b.addSubview(iv)
        b.heightAnchor.constraint(equalToConstant: 30).isActive = true
        b.widthAnchor.constraint(equalToConstant: 30).isActive = true
        b.addTarget(Any?.self, action: #selector(closeAct), for: .touchUpInside)
        
        return b
    }()
    
    // MARK: - closeAct
    @objc private func closeAct() {
        print("closeAct")
//        if UIApplication.shared.windows.first?.rootViewController is HomeVC {
//            self.dismiss(animated: true)
//        } else {
//            self.navigationController?.pushViewController(HomeVC(), animated: true)
//        }
        
//        let viewController = UIApplication.shared.windows.first?.rootViewController as? HomeVC
//        let viewController = UIApplication.shared.keyWindow?.rootViewController
//        UIApplication.shared.windows.last?.rootViewController
        
          //✅

            
        
//            .transitionCurlDown  .transitionFlipFromBottom
        guard let window = AppDelegate.window else { return }
        UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromBottom, animations: {
            window.rootViewController = CustomNav(rootViewController: HomeVC())
        }, completion:
        { completed in
            // maybe do something on completion here
        })
        
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - view Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        // UI
        setupVCStyle()
        setNavStyle()
        setupUI()
        
        setupPaywall()
        

        
        setOnboardingObserver()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    // MARK: - setOnboardingObserver
    private func setOnboardingObserver() {
        observer = UserDefaults.standard.observe(\.onboardingIsCompleted, options: [.initial, .new], changeHandler: { (defaults, change) in

            print("Defaults onboardingIsCompleted : \(defaults.onboardingIsCompleted)")
            if defaults.onboardingIsCompleted == true {
                self.configureOnboarding(isCompleted: true)
            } else {
                self.configureOnboarding(isCompleted: false)
            }
        })
    }
    
    // MARK: - configure Onboarding
     func configureOnboarding(isCompleted: Bool) {
        
        let dataArr = PaywallViewModel().paywallDataArr
        
        self.promoImage.fadeTransition(0.3)
        self.promoTitle.fadeTransition(0.3)
        self.subtitle.fadeTransition(0.3)
        
        if isCompleted {
            self.showPaywallUI(canShow: true)
            // Paywall
            self.promoImage.image = UIImage(named: dataArr[3].imageName)
            self.promoTitle.text = dataArr[3].title
            self.subtitle.text = dataArr[3].subtitle
        } else {
            self.showPaywallUI(canShow: false)
            // Onboarding
            guard self.currentPageIndex <= 3 else { return }
            self.promoImage.image = UIImage(named: dataArr[self.currentPageIndex].imageName)
            self.promoTitle.text = dataArr[self.currentPageIndex].title
            self.subtitle.text = dataArr[self.currentPageIndex].subtitle
        }    
    }
    
    // MARK: - show Paywall UI
    private func showPaywallUI(canShow: Bool) {
        
        if canShow {
            //Show
            closeButton.isHidden = false
            // termsButton
            termsButton.setTitleColor(AppColors.gray2, for: .normal)
            termsButton.isEnabled = true
            // privacyButton
            privacyButton.setTitleColor(AppColors.gray2, for: .normal)
            privacyButton.isEnabled = true
            // restoreButton
            restoreButton.setTitleColor(AppColors.gray2, for: .normal)
            restoreButton.isEnabled = true
        } else {
            // Hide
            closeButton.isHidden = true
            // termsButton
            termsButton.setTitleColor(.clear, for: .disabled)
            termsButton.isEnabled = false
            // privacyButton
            privacyButton.setTitleColor(.clear, for: .disabled)
            privacyButton.isEnabled = false
            // restoreButton
            restoreButton.setTitleColor(.clear, for: .disabled)
            restoreButton.isEnabled = false
        }
    }

    
    
    
    
}




extension PaywallVC {
    
    // MARK: - set Nav Style
    private func setNavStyle() {
        self.navigationController?.navigationBar.backgroundColor = .clear
    }
    
    // MARK: - Style
    private func setupVCStyle() {
        self.view.backgroundColor = .black
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        
        
        // Docs Stack
//        let docsStack = UIStackView(arrangedSubviews: [termsButton,restoreButton,privacyButton])
        
        
        docsStack.addArrangedSubview(termsButton)
        docsStack.addArrangedSubview(restoreButton)
        docsStack.addArrangedSubview(privacyButton)
        docsStack.axis = .horizontal
        docsStack.spacing = 0
        docsStack.distribution = .fillEqually
        
        // button stack
        let buttonStack = UIStackView(arrangedSubviews: [continueBtn,docsStack])
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
        textStack.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
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
        self.view.addSubview(closeButton)
        
        // Margin
        let viewMargin = self.view.layoutMarginsGuide
        // Stack values
//        let left: CGFloat = 16
//        let right: CGFloat = -16
//        let width: CGFloat = right - left
        
        
        NSLayoutConstraint.activate([
            
            closeButton.topAnchor.constraint(equalTo: viewMargin.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: viewMargin.trailingAnchor),
            
            promoImage.heightAnchor.constraint(lessThanOrEqualToConstant: 487),
            
            contentStack.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 47),
            contentStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            contentStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            contentStack.bottomAnchor.constraint(equalTo: viewMargin.bottomAnchor, constant: -0),
            
        ])
    }
        
}


// MARK: - Apphud
extension PaywallVC {
    // MARK: - Paywall
    private func setupPaywall() {
        

//            UserDefaults.standard.setValue(Apphud.hasPremiumAccess(), forKey: "UserAccessObserverKey")
//            UserDefaults.standard.synchronize()
        
        
        Apphud.paywallsDidLoadCallback { paywalls in
            
            if let paywall = paywalls.first(where: { $0.identifier == "Paywall_1" }) {
                print(paywall.json)

                let products = paywall.products
                
//                print(products[0].name)
//                print(products[0].skProduct)
                
                let product = products[0]
                self.apphudProduct = product
                
                print(product.productId)
                print(product.name)
                
//                self.skProduct = product
//                print("skProduct -- ",products[0].skProduct)
//                print("skProduct - priceLocale -- ",product?.priceLocale)
//                print("skProduct - price -- ",product?.price)
//                print("skProduct - localizedTitle -- ",product?.localizedTitle)
                
                
                Apphud.paywallShown(paywall)
            }
        }
        
    }
    // MARK: - Purchase
    private func makePurchase(product: ApphudProduct) {
        
//        UserDefaults.standard.setValue(true, forKey: "OnboardingCompletedKey")
//        UserDefaults.standard.synchronize()
        
        
        
        continueBtn.activityIndicatorView.startAnimating()
        Apphud.purchase(product) { [weak self] result in
            guard let self = self else{ return }
            if let subscription = result.subscription, subscription.isActive() {
                self.continueBtn.activityIndicatorView.stopAnimating()
                
            } else {
                self.continueBtn.activityIndicatorView.stopAnimating()
                print("Error")
            }
        }
    }
    
}
