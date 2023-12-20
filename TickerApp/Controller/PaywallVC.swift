//
//  OnboardingVC.swift
//  TickerApp
//
//  Created by Serj on 08.10.2023.
//

import UIKit
import ApphudSDK
import StoreKit
import SafariServices

final class PaywallVC: UIViewController {
    
    var onboardingObserver: NSKeyValueObservation?
    var apphudProduct: ApphudProduct?
    
    // MARK: - currentPageIndex
    var currentPageIndex = 0 {
        didSet {
            print(currentPageIndex)
            if currentPageIndex > 4 {
                currentPageIndex = 4
            }
        }
    }
    
    // MARK: - docs Stack
    let docsStack = UIStackView(arrangedSubviews: [])
    
    // MARK: - continue Btn ➡️
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
    // MARK: - nextAct ➡️
    @objc private func nextAct(_ sender: BigButton) {
        
        let onboarding = UserDefaults.standard.object(forKey: "OnboardingCompletedKey") as? Bool
        guard let product = self.apphudProduct else { return }
        
        guard onboarding == false || onboarding == nil else {
            // MARK: - Purchase 💰
            makePurchase(product: product)
            return
        }
        
        currentPageIndex += 1
        // Request Review
        if currentPageIndex == 2 {
            self.requestReview()
        }
        
        guard currentPageIndex >= 3 else { configureOnboarding(isCompleted: false); return }
        // UI Config
        configureOnboarding(isCompleted: true)
        // End onboarding
        UserDefaults.standard.setValue(true, forKey: "OnboardingCompletedKey")
        UserDefaults.standard.synchronize()
        //
        continueBtn.setButtonTitle(text: "Try free & subscribe")
    }
    
    
    // MARK: - Promo Image
    private let promoImage: PromoImagePlaceView = {
       let v = PromoImagePlaceView()
        return v
    }()

    
    // MARK: Promo Title
    private let promoTitle: UILabel = {
        let l = UILabel()
        l.textColor = .white
        l.numberOfLines = 1
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
    
    // MARK: - Terms Button 📄
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
        
        guard let url = URL(string: "https://ledbanner-terms.web.app/") else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let safariVC = SFSafariViewController(url: url)
            safariVC.modalPresentationStyle = .pageSheet
            self.present(safariVC, animated: true)
        }
    }
    
    // MARK: - Privacy Button 📄
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
        guard let url = URL(string: "https://ledbanner-privacy.web.app/") else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let safariVC = SFSafariViewController(url: url)
            safariVC.modalPresentationStyle = .pageSheet
            self.present(safariVC, animated: true)
        }
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
        Apphud.restorePurchases{ subscriptions, purchases, error in
            let isActiveSubscription = Apphud.hasActiveSubscription()
            UserDefaults.standard.setValue(isActiveSubscription, forKey: "UserIsPremiumObserverKey")
            UserDefaults.standard.synchronize()
        }
        
    }
    
    // MARK: - closeButton ❌
    private let closeButton: UIButton = {
        let b = UIButton() // customView: type
        b.translatesAutoresizingMaskIntoConstraints = false
        let configImage = UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)) // 25~30x30-frame
        let iv = UIImageView(image: configImage)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = AppColors.gray2
        iv.isUserInteractionEnabled = false
        b.addSubview(iv)
        b.heightAnchor.constraint(equalToConstant: 30).isActive = true
        b.widthAnchor.constraint(equalToConstant: 30).isActive = true
        b.addTarget(Any?.self, action: #selector(closeAct), for: .touchUpInside)
        // State
        b.isHidden = true
        return b
    }()
    
    // MARK: - closeAct
    @objc private func closeAct() {
        guard let window = AppDelegate.window else { return }
        UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromBottom, animations: {
            window.rootViewController = CustomNav(rootViewController: HomeVC())
        })
    }
    
    
    // MARK: - view Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        // UI
        setupVCStyle()
        setNavStyle()
        setupUI()
        //
        setupPaywall { _ in }
        setOnboardingObserver()
    }
    
    // MARK: - view Did Layout Subviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    // MARK: - setOnboardingObserver
    private func setOnboardingObserver() {
        onboardingObserver = UserDefaults.standard.observe(\.onboardingIsCompleted, options: [.initial, .new], changeHandler: { (defaults, change) in

            print("🔵 Defaults onboardingIsCompleted: \(defaults.onboardingIsCompleted)")
            if defaults.onboardingIsCompleted == true {
                self.configureOnboarding(isCompleted: true)
            } else {
                self.configureOnboarding(isCompleted: false)
            }
        })
    }
    
    // MARK: - configure Onboarding 📗
     func configureOnboarding(isCompleted: Bool) {
        
        let dataArr = PaywallViewModel().paywallDataArr
        // Text animation
        self.promoImage.fadeTransition(0.3)
        self.promoTitle.fadeTransition(0.3)
        self.subtitle.fadeTransition(0.3)
        
        if isCompleted {
            self.showPaywallUI(canShow: true)
            // Paywall
            self.promoImage.setImage(named: dataArr[3].imageName)
            // удаленный конфиг из AppHud хотел сделать
            
            //
//            print("🔴 isCompleted - 1", isCompleted)
            // v1
//            self.promoTitle.text = dataArr[3].title
//            self.subtitle.text = dataArr[3].subtitle
            //
//            DispatchQueue.main.async {
//                self.setupPaywall { paywall in
//                    let paywallTitle = paywall.json?["title"] as? String
//                    let paywallSubtitle = paywall.json?["subtitle"] as? String
//                    //
//                    self.promoTitle.text = paywallTitle
//                    self.subtitle.text = paywallSubtitle
//                    self.subtitle.textColor = .white
//                }
//            }
            self.promoTitle.text = "Unlock full access"
//            self.subtitle.text = """
//            • 3 days free trial\n• 4.99 $ / 7 days\n• Or proceed with limited version
//            """
//            • 4.99 $ per week\n• 3-day free trial included\n• Or proceed with limited version
            
            let mainString = "4.99 $ per week\n3-day free trial included\nOr use limited version"
            let stringToColor = "4.99 $ per week"
            
            let range = (mainString as NSString).range(of: stringToColor)
            let mutableAttributedString = NSMutableAttributedString.init(string: mainString)
            mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
            mutableAttributedString.addAttribute(NSAttributedString.Key.font, value: SFProRounded.set(fontSize: 20, weight: .semibold), range: range)
            self.subtitle.attributedText = mutableAttributedString

        } else {
            
            self.showPaywallUI(canShow: false)
            // Onboarding
            guard self.currentPageIndex <= 3 else { return }
            
            self.promoImage.setImage(named: dataArr[self.currentPageIndex].imageName)
            //
            self.promoTitle.text = dataArr[self.currentPageIndex].title
            self.subtitle.text = dataArr[self.currentPageIndex].subtitle
        }    
    }
    
    // MARK: - show Paywall UI
    private func showPaywallUI(canShow: Bool) {
        
        let onboarding = UserDefaults.standard.object(forKey: "OnboardingCompletedKey") as? Bool
        if onboarding == true {
            continueBtn.setButtonTitle(text: "Try free & subscribe")
        }
        
        if canShow {
            //Show
            // closeButton
            setupPaywall { paywall in
                let val = paywall.json?["isCloseHiden"] as? Bool
                guard let val = val else { return }
                self.closeButton.isHidden = val
            }
            
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
        docsStack.addArrangedSubview(termsButton)
        docsStack.addArrangedSubview(restoreButton)
        docsStack.addArrangedSubview(privacyButton)
        //
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
        textStack.distribution = .fill
        textStack.spacing = 8
        textStack.layoutMargins = UIEdgeInsets(top: 16, left: 12, bottom: 32, right: 12)
        textStack.isLayoutMarginsRelativeArrangement = true
        
        // Content Stack
        let contentStack = UIStackView(arrangedSubviews: [promoImage,textStack,buttonStack])
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.alignment = .center
        contentStack.distribution = .fill
        
        // Subview
        self.view.addSubview(contentStack)
        self.view.addSubview(closeButton)
        
        // Margin
        let viewMargin = self.view.layoutMarginsGuide
//        let statusBar = UIApplication.shared.statusBarFrame.height
        
        NSLayoutConstraint.activate([
            
            promoImage.topAnchor.constraint(equalTo: contentStack.topAnchor),
            promoImage.bottomAnchor.constraint(equalTo: textStack.topAnchor),
            promoImage.widthAnchor.constraint(equalTo: contentStack.widthAnchor),
            
            textStack.leadingAnchor.constraint(equalTo: contentStack.leadingAnchor),
            textStack.trailingAnchor.constraint(equalTo: contentStack.trailingAnchor),
            
            closeButton.topAnchor.constraint(equalTo: viewMargin.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: viewMargin.trailingAnchor),
            
            contentStack.topAnchor.constraint(equalTo: viewMargin.topAnchor, constant: 0),
            contentStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            contentStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            contentStack.bottomAnchor.constraint(equalTo: viewMargin.bottomAnchor, constant: -0),
            
        ])
    }
}


// MARK: - Apphud
extension PaywallVC {
    // MARK: - setup Paywall
    private func setupPaywall(handler: @escaping (ApphudPaywall) -> Void ) {
        
        Apphud.paywallsDidLoadCallback { paywalls in
            // желательно переделать одним вызовом
            if let paywall = paywalls.first(where: { $0.identifier == "Paywall_1" }) {
                // get product
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    let products = paywall.products
                    let product = products[0]
                    self.apphudProduct = product
                    // Paywall
                    handler(paywall)
                }
                
                
                // paywall title
                
//                let paywallTitle = paywall.json?["title"] as? String
//                let paywallSubtitle = paywall.json?["subtitle"] as? String
//                self.paywallTitle = paywallTitle
//                self.paywallSubtitle = paywallSubtitle
//
//                print("✅ paywallTitle -", paywallTitle)
//                print("✅ paywallSubtitle -", paywallSubtitle)
//
//                paywallTitle
//                paywallSubtitle
                
                
                
                // close Button
//                let val = paywall.json?["isCloseHiden"] as? Bool
//                guard let val = val else { return }
//                self.closeButton.isHidden = val ? true : false
//                print("✅ Button State - ", val)
                //
                
                
//                print("🟣",self.apphudProduct?.skProduct?.price)
//                print("🟣",self.apphudProduct?.skProduct?.priceLocale)
//                print("🟣",self.apphudProduct?.skProduct?.apphudLocalizedPrice())
//                print("🟣",self.apphudProduct?.price)
                
                
                
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

        continueBtn.activityIndicatorView.startAnimating()
        Apphud.purchase(product) { [weak self] result in
            guard let self = self else { return }
            if let subscription = result.subscription, subscription.isActive() {
                // Save Status
                UserDefaults.standard.setValue(true, forKey: "UserIsPremiumObserverKey")
                UserDefaults.standard.synchronize()
                //
                self.continueBtn.activityIndicatorView.stopAnimating()
                self.closeAct()
            } else {
                self.continueBtn.activityIndicatorView.stopAnimating()
                print("Error")
            }
        }
    }
    
    // MARK: - make Price not need // Возможно позже понадобится!
//    private func makePrice(product: ApphudProduct) -> String {
//        // Number Formatter
//        guard
//            let price = product.skProduct?.price,
//            let locale = product.skProduct?.priceLocale
//        else { return "" }
//        let numberFormatter = NumberFormatter()
//        numberFormatter.formatterBehavior = .behavior10_4
//        numberFormatter.numberStyle = .currency
//        numberFormatter.locale = locale
//        let formattedPrice = numberFormatter.string(from: price)
//
//        return formattedPrice ?? ""
////        print("✅ formattedPrice - ", formattedPrice as Any)
//    }
    
}


