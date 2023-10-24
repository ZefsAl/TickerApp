//
//  EditBannerVC.swift
//  TickerApp
//
//  Created by Serj on 05.10.2023.
//

import UIKit
import MaterialComponents.MaterialTabs_TabBarView
import RealmSwift
import Combine


final class EditBannerVC: UIViewController {
    
    // MARK: - Realm
    let realm = try! Realm()
    
    
    // MARK: - TickerView
    // Для хранения примененных параметров из Collection
    static var tickerView: TickerView = TickerView() // 👎
    
    
    // MARK: - tickerDataModel
    var tickerDataModel: TickerDataModel?
    
    
    
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
        b.addTarget(Any?.self, action: #selector(saveAct), for: .touchUpInside)
        return b
    }()
    // MARK: - Save Act
    @objc private func saveAct(_ sender: MediumButton) {
        print("saveAct")
        
        
        
        
        // get selected indexPath from CV
        let effectData = encodeIndexPath(indexPathArr: effectSettingsCV.selectedEffectIndexPath)
        let textData = encodeIndexPath(indexPathArr: textSettingsCV.selectedTextIndexPath)
        let backgroundData = encodeIndexPath(indexPathArr: backgroundSettingsCV.selectedBackgroundIndexPath)
        
        
//        print("effectData - ",effectData,"textData - ",textData,"backgroundData - ", backgroundData)
        
        // Add item
        EditBannerVC.tickerView.getTickerConfig { model in
            
            // Add New
            if self.tickerDataModel == nil {
                try! self.realm.write {
                    self.realm.add(model)
                    model.selectedEffectIndexData = effectData
                    model.selectedTextIndexData = textData
                    model.selectedBackgroundIndexData = backgroundData
                    self.realm.refresh()
                }
            }

            
            // Update тоже setSelectCV сохранить измененные selected settings
            // Не должны сохранять пустой [] eckb [] то вернуть предыдущее сохранение
            //                    (effectData == []) ? effectData : model.selectedEffectIndexData
            
            // Update
            guard let oldModel = self.tickerDataModel else { return }
            
            var newEffectData: Data {
                if self.effectSettingsCV.selectedEffectIndexPath != [] {
                    return encodeIndexPath(indexPathArr: self.effectSettingsCV.selectedEffectIndexPath)
                } else {
                    return oldModel.selectedEffectIndexData
                }
            }
            
            var newTextData: Data {
                if self.textSettingsCV.selectedTextIndexPath != [] {
                    return encodeIndexPath(indexPathArr: self.textSettingsCV.selectedTextIndexPath)
                } else {
                    return oldModel.selectedTextIndexData
                }
            }
            
            var newBackgroundData: Data {
                if self.backgroundSettingsCV.selectedBackgroundIndexPath != [] {
                    return encodeIndexPath(indexPathArr: self.backgroundSettingsCV.selectedBackgroundIndexPath)
                } else {
                    return oldModel.selectedBackgroundIndexData
                }
                    
            }
            
            
            // find
            let object = self.realm.objects(TickerDataModel.self).where {
                $0._id == oldModel._id
            }.first!
            print(model)
            // Set new
            try! self.realm.write {

                object.inputText = model.inputText
                object.textColor = model.textColor
                object.textSpeed = model.textSpeed
                object.bgColor = model.bgColor
                object.fontName = model.fontName
                object.fontSize = model.fontSize
         
                
                
                object.selectedEffectIndexData = newEffectData
                object.selectedTextIndexData = newTextData
                object.selectedBackgroundIndexData = newBackgroundData
                
            }
        }
        
        
        
        
    }
    
    // MARK: - close
    private let close: CircleButton = {
        let b = CircleButton(
            frame: .zero,
            bgColor: AppColors.gray5,
            iconSystemName: "xmark",
            iconColor: AppColors.gray2
        )
        b.addTarget(Any?.self, action: #selector(closeAct), for: .touchUpInside)
        return b
    }()
    @objc private func closeAct(_ sender: MediumButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - delete
    private let delete: CircleButton = {
        let b = CircleButton(
            frame: .zero,
            bgColor: AppColors.gray5,
            iconSystemName: "trash.fill",
            iconColor: AppColors.gray2
        )
        b.addTarget(Any?.self, action: #selector(deleteAct), for: .touchUpInside)
        return b
    }()
    
    // MARK: - delete Actions
    @objc private func deleteAct(_ sender: MediumButton) {
        
        let alert = UIAlertController(title: "Delete?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { act in
//            find
            guard let model = self.tickerDataModel else { print("Empty"); return }
            // compare id
            let object = self.realm.objects(TickerDataModel.self).where {
                $0._id == model._id
            }.first!
            // delete by id
            try! self.realm.write {
                self.realm.delete(object)
            }
            self.navigationController?.popToRootViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { act in
            alert.dismiss(animated: true)
        }))
        self.present(alert, animated: true)
        
    }
    
    
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
        b.addTarget(Any?.self, action: #selector(playAct), for: .touchUpInside)
        return b
    }()
    @objc private func playAct(_ sender: MediumButton) {
        self.navigationController?.pushViewController(TickerPlayVC(tickerDataModel: tickerDataModel), animated: true)
        
    }
    
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
        settingsScrollViewUI()
        
    }
    
    // MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        print("viewDidAppear - SV = \(settingsScrollView.frame)") // 👎
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    
    // MARK: - init
    init(tickerDataModel: TickerDataModel?) {
        super.init(nibName: nil, bundle: nil)
        
        print("MODEL - tickerDataModel -", tickerDataModel as Any)
        
        // Select cells by data
        // Effect
        if let data = tickerDataModel?.selectedEffectIndexData {
            print(decodeIndexPath(indexPathData: data) as Any)
            setSelectCV(indexData: data, collection: effectSettingsCV)
        }
        // Text
        if let data = tickerDataModel?.selectedTextIndexData {
            print(decodeIndexPath(indexPathData: data) as Any)
            setSelectCV(indexData: data, collection: textSettingsCV)
        }
        // Background
        if let data = tickerDataModel?.selectedBackgroundIndexData {
            print(decodeIndexPath(indexPathData: data) as Any)
            setSelectCV(indexData: data, collection: backgroundSettingsCV)
        }
        
        
        
        
        // New Banner
        if tickerDataModel == nil {
            self.tickerDataModel = nil
            EditBannerVC.tickerView = TickerView()
            EditBannerVC.tickerView.configTickerLayout(width: self.view.frame.size.width)
        }
        
        
        // Update Banner
        if let model = tickerDataModel {
            self.tickerDataModel = tickerDataModel
            EditBannerVC.tickerView.configureTicker(tickerDataModel: model, frameWidth: self.view.frame.size.width)
            self.regularTextField.text = model.inputText
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - set Select CV
    private func setSelectCV(indexData: Data?, collection: EditSettingsCV) {
        guard
            let data = indexData,
            let indexArr = decodeIndexPath(indexPathData: data)
        else { return }
        
        for index in indexArr {
            DispatchQueue.main.async {
                collection.selectItem(
                    at: index,
                    animated: true,
                    scrollPosition: .left
                )
            }
        }

    }
    
    // MARK: - set Delegate
    private func setDelegates() {
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
        EditBannerVC.tickerView.setInputText(text: text)
        
    }
}



// MARK: - Delegate Tab Bar View
extension EditBannerVC: MDCTabBarViewDelegate {
    
    func tabBarView(_ tabBarView: MDCTabBarView, didSelect item: UITabBarItem) {
//        print("TAG --- \(String(describing: tabBarView.selectedItem?.tag))")

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
        let headerStack = UIStackView(arrangedSubviews: [close,delete,UIView(),save])
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
        let tickerStack = UIStackView(arrangedSubviews: [EditBannerVC.tickerView,inputStack])
        tickerStack.translatesAutoresizingMaskIntoConstraints = false
        tickerStack.axis = .vertical
        tickerStack.alignment = .fill
        tickerStack.spacing = 16
        
        tickerStack.layoutMargins = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        tickerStack.isLayoutMarginsRelativeArrangement = true
        
        // Content Stack
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
            
            EditBannerVC.tickerView.heightAnchor.constraint(equalToConstant: 160),

            contentStack.topAnchor.constraint(equalTo: viewMargin.topAnchor, constant: top),
            contentStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: left),
            contentStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: right),
//            contentStack.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -0),

            bottomStack.topAnchor.constraint(equalTo: contentStack.bottomAnchor, constant: 32),
            bottomStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bottomStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bottomStack.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
        ])
    }
    
    // MARK: - SettingsScrollViewUI
    func settingsScrollViewUI() {

        settingsScrollView.contentSize = CGSize(width: view.frame.size.width*3, height: settingsScrollView.frame.size.height)
        settingsScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        settingsScrollView.isPagingEnabled = true
        
        
//        let viewSizeWidth = self.view.frame.size.width
        
        for slide in 0..<3 {
            
            if slide == 0 {
                
                effectSettingsCV.frame = CGRect(
                    x: CGFloat(slide) * self.view.frame.size.width,
                    y: 0,
                    width: self.view.frame.size.width,
                    height: self.view.frame.size.height
                )
                
                settingsScrollView.addSubview(effectSettingsCV)
            }
            if slide == 1 {
                textSettingsCV.frame = CGRect(
                    x: CGFloat(slide) * self.view.frame.size.width,
                    y: 0,
                    width: self.view.frame.size.width,
                    height: self.view.frame.size.height
                )
                
                settingsScrollView.addSubview(textSettingsCV)
            }
            if slide == 2 {
                backgroundSettingsCV.frame = CGRect(
                    x: CGFloat(slide) * self.view.frame.size.width,
                    y: 0,
                    width: self.view.frame.size.width,
                    height: self.view.frame.size.height
                )

                settingsScrollView.addSubview(backgroundSettingsCV)
            }
            
        }
    }
    
}
