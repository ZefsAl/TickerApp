//
//  EditBannerVC.swift
//  TickerApp
//
//  Created by Serj on 05.10.2023.
//

import UIKit
import MaterialComponents.MaterialTabs_TabBarView

final class EditBannerVC: UIViewController {

    // MARK: - save
    private let save: MediumButton = {
        let b = MediumButton(
            frame: .zero,
            bgColor: AppColors.secondary,
            title: "Save",
            titleColor: AppColors.primary,
            iconSystemName: "checkmark.circle",
            iconColor: AppColors.primary,
            hideTitle: false
        )
        return b
    }()
    // MARK: - close
    private let close: CircleButton = {
        let b = CircleButton(
            frame: .zero,
            bgColor: AppColors.gray5,
            iconSystemName: "xmark",
            iconColor: AppColors.gray2
        )
        return b
    }()
    // MARK: - edit
    private let edit: CircleButton = {
        let b = CircleButton(
            frame: .zero,
            bgColor: AppColors.gray5,
            iconSystemName: "ellipsis.circle.fill",
            iconColor: AppColors.gray2
        )
        return b
    }()
    // MARK: - TickerView
    private let tickerView: TickerView =  EditSettingsVM.tickerView  // viewDidAppear
    
    // MARK: - play
    private let play: MediumButton = {
        let b = MediumButton(
            frame: .zero,
            bgColor: AppColors.primary,
            title: nil,
            titleColor: nil,
            iconSystemName: "play.fill",
            iconColor: AppColors.secondary,
            hideTitle: true
        )
        return b
    }()
    
    // MARK: - Text Field
    private let regularTextField = RegularTextField(
        frame: .null,
        setPlaceholder: "Input text here!"
    );
    
    // MARK: - Scroll View
    private let settingsScrollView: UIScrollView = {
       let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsHorizontalScrollIndicator = false
        sv.isScrollEnabled = false
//        sv.showsVerticalScrollIndicator = false
//        sv.alwaysBounceVertical = true
        sv.backgroundColor = AppColors.gray5
        return sv
    }()
    
    
    
    
    // MARK: - Collection View
//    private let effectSettingsCV = EditSettingsCV(frame: .null, collectionViewLayout: UICollectionViewLayout.init(), editSettingsModel: EditSettingsVM().effectSettings)
    private let effectSettingsCV = EditSettingsCV(frame: .null, collectionViewLayout: UICollectionViewLayout.init(), editSettingsModel: EditSettingsVM().effectSettingsModel)
    
    private let textSettingsCV = EditSettingsCV(frame: .null, collectionViewLayout: UICollectionViewLayout.init(), editSettingsModel: EditSettingsVM().textSettingsModel)
    
    private let backgroundSettingsCV = EditSettingsCV(frame: .null, collectionViewLayout: UICollectionViewLayout.init(), editSettingsModel: EditSettingsVM().backgroundSettingsModel)

    
    
    // MARK: - tab Bar View
    private let tabBarView: MDCTabBarView = {

        let tb = MDCTabBarView()
        // Tab Bar Style
        tb.backgroundColor = AppColors.gray6
        tb.bottomDividerColor = AppColors.gray2
        tb.rippleColor = .clear
        // Selected
        tb.selectionIndicatorStrokeColor = AppColors.primary
        let tabFont = SFProRounded.set(fontSize: 14, weight: .heavy)
        tb.setTitleFont(tabFont, for: .selected)
        tb.setTitleColor(AppColors.primary, for: .selected)
        // Normal
        tb.setTitleColor(AppColors.gray2, for: .normal)
        tb.setTitleFont(tabFont, for: .normal)
        
        
        
        // Items
        tb.items = [
            UITabBarItem(title: "Efect", image: nil, tag: 0),
            UITabBarItem(title: "Text", image: nil, tag: 1),
            UITabBarItem(title: "Background", image: nil, tag: 2),
        ]
        
        tb.setSelectedItem(tb.items[0], animated: true)
        
        
        return tb
    }()
    
    
    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        // delegate
        setDelegates()
        // UI
        setupUI()
        
    }
    
// MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear - SV = \(settingsScrollView.frame)") // 👎
        settingsScrollViewUI()
    }
    
    // MARK: - Delegate
    func setDelegates() {
        // delegate
        tabBarView.tabBarDelegate = self
        settingsScrollView.delegate = self
        regularTextField.delegate = self
    }

}

// MARK: - Delegate text field
extension EditBannerVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let text = textField.text else { return }
        tickerView.setInputText(text: text)
    }
}

/// MARK: - config Ticker
//extension EditBannerVC {
//    func configTicker() {
////        по value changed - внутри viewDidAppear - configTicker
//        
//    }
//}


// MARK: - Delegate Tab Bar View
extension EditBannerVC: MDCTabBarViewDelegate {
    
    func tabBarView(_ tabBarView: MDCTabBarView, didSelect item: UITabBarItem) {
        print("TAG --- \(String(describing: tabBarView.selectedItem?.tag))")
        
//        tabBarView.selected

        // Set Content Offset
        if let tag = tabBarView.selectedItem?.tag {
            settingsScrollView.setContentOffset(CGPoint(x: CGFloat(tag) * settingsScrollView.frame.size.width, y: 0), animated: true)
        }
    }
}


// MARK: - Delegate UIScrollView
extension EditBannerVC: UIScrollViewDelegate {
    // scrollViewDidScroll + setSelectedItem работает нормально но!
    var page: Int {
        let page = Int(floorf(Float(settingsScrollView.contentOffset.x) / Float(settingsScrollView.frame.size.width)))
        if page < 0 {
            return 0
        } else if page > 2 {
            return 2
        } else {
            return page
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        print(page)
//        tabBarView.setSelectedItem(tabBarView.items[page], animated: true)
       
// MARK: - переключать tabBarView по свайпу Нуждается в доработке!
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        print("ScrollingAnimation")
//        print("Page offset --- \(page)")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("EndDragging")
        
        // переключать tabBarView по свайпу

//        print("Page offset --- \(page)")
//        print("TAG --- \(String(describing: tabBarView.selectedItem?.tag))")
        
//        if page >= 0 && page <= 2 {
//            tabBarView.setSelectedItem(tabBarView.items[page], animated: true)
//        }
        
//        guard let tag = tabBarView.selectedItem?.tag else { return }
//
//        if page == tag {
//            tabBarView.setSelectedItem(tabBarView.items[page], animated: true)
//        }
        
        
//        tabBarView.setSelectedItem(tabBarView.items[page], animated: true)
//        if page == 0 {
//            tabBarView.setSelectedItem(tabBarView.items[0], animated: true)
//        } else if page == 1 {
//            tabBarView.setSelectedItem(tabBarView.items[1], animated: true)
//        } else if page == 2 {
//            tabBarView.setSelectedItem(tabBarView.items[2], animated: true)
//        }
        
        
        
    }
}




// MARK: - Setup UI
extension EditBannerVC {
    
    private func setupUI() {
        
        
        // header
        let headerStack = UIStackView(arrangedSubviews: [close,edit,UIView(),save])
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        headerStack.axis = .horizontal
        headerStack.alignment = .fill
        headerStack.spacing = 24
        
        // inputStack
        let inputStack = UIStackView(arrangedSubviews: [regularTextField,play])
        inputStack.translatesAutoresizingMaskIntoConstraints = false
        inputStack.axis = .horizontal
        inputStack.alignment = .fill
        inputStack.spacing = 8
        
        // tickerStack
        let tickerStack = UIStackView(arrangedSubviews: [tickerView,inputStack])
        tickerStack.translatesAutoresizingMaskIntoConstraints = false
        tickerStack.axis = .vertical
        tickerStack.alignment = .fill
        tickerStack.spacing = 16
        
        tickerStack.layoutMargins = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        tickerStack.isLayoutMarginsRelativeArrangement = true
        
        // MARK: Content Stack
        let contentStack = UIStackView(arrangedSubviews: [headerStack,tickerStack])
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.alignment = .fill
        contentStack.spacing = 0
        self.view.addSubview(contentStack)


        
        // bottomStack
        let bottomStack = UIStackView(arrangedSubviews: [tabBarView,settingsScrollView])
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        bottomStack.axis = .vertical
        bottomStack.alignment = .fill
        bottomStack.spacing = 0
        
        self.view.addSubview(bottomStack)
        
        
//        // Stack
        let top: CGFloat = 16
        let left: CGFloat = 16
        let right: CGFloat = -16
//        let width: CGFloat = right - left
        
        let viewMargin = self.view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            
//            regularTextField.widthAnchor.less
            
            tickerView.heightAnchor.constraint(equalToConstant: 160),

            contentStack.topAnchor.constraint(equalTo: viewMargin.topAnchor, constant: top),
            contentStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: left),
            contentStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: right),
//            contentStack.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -0),

            bottomStack.topAnchor.constraint(equalTo: contentStack.bottomAnchor, constant: 32),
            bottomStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bottomStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bottomStack.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            
//            settingsScrollView.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 0),
//            settingsScrollView.leadingAnchor.constraint(equalTo: bottomStack.leadingAnchor),
//            settingsScrollView.trailingAnchor.constraint(equalTo: bottomStack.trailingAnchor),
//            settingsScrollView.bottomAnchor.constraint(equalTo: bottomStack.bottomAnchor),
            
            
//            effectSettingsCV.topAnchor.constraint(equalTo: settingsScrollView.topAnchor),
//            effectSettingsCV.leadingAnchor.constraint(equalTo: settingsScrollView.leadingAnchor),
//            effectSettingsCV.trailingAnchor.constraint(equalTo: settingsScrollView.trailingAnchor),
//            effectSettingsCV.bottomAnchor.constraint(equalTo: settingsScrollView.bottomAnchor),
            
            
//            effectSettingsCV.heightAnchor.constraint(equalToConstant: 500),
//            effectSettingsCV.widthAnchor.constraint(equalToConstant: 350),
            
            
            
//            settingsScrollView.widthAnchor.constraint(equalTo: bottomStack.widthAnchor),
            
//            effectSettingsCV.widthAnchor.constraint(equalTo: bottomStack.widthAnchor),
//            textSettingsCV.widthAnchor.constraint(equalTo: bottomStack.widthAnchor),
            
//            editSettingsCV.leadingAnchor.constraint(equalTo: bottomStack.leadingAnchor),
//            editSettingsCV.trailingAnchor.constraint(equalTo: bottomStack.trailingAnchor),
//            editSettingsCV.widthAnchor.constraint(equalTo: bottomStack.widthAnchor),
            
//            editSettingsCV.topAnchor.constraint(equalTo: bottomStack.topAnchor),
//            editSettingsCV.bottomAnchor.constraint(equalTo: bottomStack.bottomAnchor),
            
        ])
    }
    
    // MARK: - settingsScrollViewUI
    func settingsScrollViewUI() {
//        effectSettingsCV.frame = CGRect(x: 0, y: 0, width: settingsScrollView.frame.size.width, height: settingsScrollView.frame.size.height)
//
//        textSettingsCV.frame = CGRect(x: 0, y: 0, width: settingsScrollView.frame.size.width, height: settingsScrollView.frame.size.height)
                
//        effectSettingsCV.frame = CGRect(x: 0, y: 0, width: 350, height: 350)
//        settingsScrollView.addSubview(effectSettingsCV)
        
        
        
        settingsScrollView.contentSize = CGSize(width: view.frame.size.width*3, height: settingsScrollView.frame.size.height)
        
        settingsScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        settingsScrollView.isPagingEnabled = true
        
        
        
        for slide in 0..<3 {
            
            if slide == 0 {
                
                effectSettingsCV.frame = CGRect(
                    x: CGFloat(slide) * settingsScrollView.frame.size.width,
                    y: 0,
                    width: settingsScrollView.frame.size.width,
                    height: settingsScrollView.frame.size.height
                )
                
                settingsScrollView.addSubview(effectSettingsCV)
            }
            if slide == 1 {
                textSettingsCV.frame = CGRect(
                    x: CGFloat(slide) * settingsScrollView.frame.size.width,
                    y: 0,
                    width: settingsScrollView.frame.size.width,
                    height: settingsScrollView.frame.size.height
                )
                
                settingsScrollView.addSubview(textSettingsCV)
            }
            if slide == 2 {
                backgroundSettingsCV.frame = CGRect(
                    x: CGFloat(slide) * settingsScrollView.frame.size.width,
                    y: 0,
                    width: settingsScrollView.frame.size.width,
                    height: settingsScrollView.frame.size.height
                )

                settingsScrollView.addSubview(backgroundSettingsCV)
            }
            
        }
    }
    
}
