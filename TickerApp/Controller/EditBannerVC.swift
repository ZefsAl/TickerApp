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
    private let tickerView = TickerView()
    
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
//        sv.isScrollEnabled = false
//        sv.showsVerticalScrollIndicator = false
//        sv.alwaysBounceVertical = true
        sv.backgroundColor = AppColors.gray5
        return sv
    }()
    
    
    
    // MARK: - Collection View
    private let effectSettingsCV = EditSettingsCV(frame: .null, collectionViewLayout: UICollectionViewLayout.init(), editSettingsVM: EditSettingsVM())
    
    private let textSettingsCV = EditSettingsCV(frame: .null, collectionViewLayout: UICollectionViewLayout.init(), editSettingsVM: EditSettingsVM())
    
    private let backgroundSettingsCV = EditSettingsCV(frame: .null, collectionViewLayout: UICollectionViewLayout.init(), editSettingsVM: EditSettingsVM())

    
    
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
        tabBarView.tabBarDelegate = self
        settingsScrollView.delegate = self
        
        
        // UI
        setupUI()
        
    }
    
// MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear - SV = \(settingsScrollView.frame)") // 👎
        settingsScrollViewUI()
    }

}


extension EditBannerVC: MDCTabBarViewDelegate {
    
    func tabBarView(_ tabBarView: MDCTabBarView, didSelect item: UITabBarItem) {
        print("TAG --- \(String(describing: tabBarView.selectedItem?.tag))")

        // Set Content Offset
        if let tag = tabBarView.selectedItem?.tag {
            settingsScrollView.setContentOffset(CGPoint(x: CGFloat(tag) * settingsScrollView.frame.size.width, y: 0), animated: true)
        }
    }
}

extension EditBannerVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
//        let some = CGPoint(x: CGFloat(tag) / settingsScrollView.frame.size.width, y: 0)
//        let page = Int(floorf(Float(settingsScrollView.contentOffset.x) / Float(settingsScrollView.frame.size.width)))
        
//        print(page)
//        print("DidScroll")
//
//        tabBarView.setSelectedItem(tabBarView.items[page], animated: true)

    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("ScrollingAnimation")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("EndDragging")
        
        let page = Int(floorf(Float(settingsScrollView.contentOffset.x) / Float(settingsScrollView.frame.size.width)))
        
        print("page offset --- \(page)")
        print("TAG --- \(String(describing: tabBarView.selectedItem?.tag))")
        
        if page >= 0 && page <= 2 {
            
//            print(tabBarView.items.count)
            tabBarView.setSelectedItem(tabBarView.items[page], animated: true)
        }
        
        
        
    }
}




// MARK: - Setup UI
extension EditBannerVC {
    
    
//    // MARK: - Style
//    private func setupVCStyle() {
//        self.view.backgroundColor = .black
//    }
//
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


        

        
        

        
//        settingsScrollView.addSubview(textSettingsCV)
//        settingsScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: settingsScrollView.frame.size.height)
//        settingsScrollView.contentSize = CGSize(width: settingsScrollView.frame.size.width*3, height: settingsScrollView.frame.size.height)
//        settingsScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        
//        effectSettingsCV.frame = CGRect(x: 0, y: 0, width: settingsScrollView.frame.size.width, height: settingsScrollView.frame.size.height)
        
        
        
        
//        let someView: UIView = {
//           let v = UIView()
//            v.backgroundColor = .white
//            v.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
//            return v
//        }()
//        settingsScrollView.addSubview(someView)
        
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
