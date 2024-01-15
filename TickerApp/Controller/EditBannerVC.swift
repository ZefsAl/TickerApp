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
    private lazy var realm = try! Realm()
    
//    private let editSettingsViewModel = EditSettingsVM() // хотел исправить что бы был 1 запрос
    private var previousSelectedIndex: [String : [IndexPath]]?
    
    // MARK: - TickerView
    // Для хранения примененных параметров из Collection
    static var tickerView: TickerView = TickerView()
    
    
    // MARK: - tickerDataModel
    var tickerDataModel: TickerDataModel?
    
    
    // MARK: - Save ✅
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
    
    
//    // checkTest
//    @objc private func checkTest() {
//
//
////        guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems else { return }
////        selectedEffectIndexPath = selectedIndexPaths
//
////        let effect = effectSettingsCV.indexPathsForSelectedItems
////        let text = textSettingsCV.selectedTextIndexPath
////        let background = backgroundSettingsCV.selectedBackgroundIndexPath
//
////        print("⚠️",effect)
////        print("⚠️",text)
////        print("⚠️",background)
//
////        let pixel_v2 = findSelectedIndexPath_v2(editSettingsCV: effectSettingsCV, type: .effect, sectionTitle: "Pixel")
////        print("⚠️ Try to find",pixel_v2)
//
//        EditBannerVC.tickerView.getTickerConfigure { model in
//            print("⚠️ find", model.fontSize)
//        }
//
//    }
    
    // MARK: - Save Act ✅
    @objc private func saveAct() {
        
        // get selected indexPath from CV as Data
//        let effectData = encodeIndexPath(indexPathArr: effectSettingsCV.selectedEffectIndexPath)
//        let textData = encodeIndexPath(indexPathArr: textSettingsCV.selectedTextIndexPath)
//        let backgroundData = encodeIndexPath(indexPathArr: backgroundSettingsCV.selectedBackgroundIndexPath)
            
        
        let effectData = encodeIndexPath(indexPathArr: effectSettingsCV.indexPathsForSelectedItems ?? [])
        let textData = encodeIndexPath(indexPathArr: textSettingsCV.indexPathsForSelectedItems ?? [])
        let backgroundData = encodeIndexPath(indexPathArr: backgroundSettingsCV.indexPathsForSelectedItems ?? [])
        
        // Add item
        EditBannerVC.tickerView.getTickerConfigure { model in
            // Add New ✅
            if self.tickerDataModel == nil {
                try! self.realm.write {
                    self.realm.add(model)
                    model.selectedEffectIndexData = effectData
                    model.selectedTextIndexData = textData
                    model.selectedBackgroundIndexData = backgroundData
                    self.realm.refresh()
                }
            }
            
            // Update 🔄
            guard let oldModel = self.tickerDataModel else { return }
            // get new Effect setting or return - old
            var newEffectData: Data {
                if self.effectSettingsCV.selectedEffectIndexPath != [] {
                    // можно заменитть на effectData // ???
                    return effectData
                } else {
                    return oldModel.selectedEffectIndexData
                }
            }
            // get new Text setting or old
            var newTextData: Data {
                if self.textSettingsCV.selectedTextIndexPath != [] {
                    return textData
                } else {
                    return oldModel.selectedTextIndexData
                }
            }
            // get new Background setting or old
            var newBackgroundData: Data {
                if self.backgroundSettingsCV.selectedBackgroundIndexPath != [] {
                    return backgroundData
                } else {
                    return oldModel.selectedBackgroundIndexData
                }
            }
            
            // Find
            let object = self.realm.objects(TickerDataModel.self).where {
                $0._id == oldModel._id
            }.first!
            print("🟢 Save",model)
            // Update - Set new
            try! self.realm.write {
                // TickerDataModel - хотел переделать
                object.inputText = model.inputText
                object.textColor = model.textColor
                object.textSpeed = model.textSpeed
                object.bgColor = model.bgColor
                object.fontName = model.fontName
                object.fontSize = model.fontSize
                object.stroke = model.stroke
                object.shadow = model.shadow
                object.bgImage = model.bgImage
                object.isReversedScroll = model.isReversedScroll
                object.sparkleDuration = model.sparkleDuration
                //
                object.selectedEffectIndexData = newEffectData
                object.selectedTextIndexData = newTextData
                object.selectedBackgroundIndexData = newBackgroundData
            }
        }
        self.requestReview()
        UIView().hapticNotification(type: .success)
        self.navigationController?.popToRootViewController(animated: true)
        
//        checkTest()
    }
    
    // MARK: - Close ⬅️
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
    // MARK: - Close Action ⬅️
    @objc private func closeAct(_ sender: MediumButton) {
        // Логика Update и Save при изменении
        // при отсутствии изменений не запрашивать алерт (было ли изменение?)
        
        // Check select changes
        guard
            (previousSelectedIndex?["effect"] != effectSettingsCV.selectedEffectIndexPath) ||
            (previousSelectedIndex?["text"] != textSettingsCV.selectedTextIndexPath) ||
            (previousSelectedIndex?["background"] != backgroundSettingsCV.selectedBackgroundIndexPath)
        else {
            self.navigationController?.popToRootViewController(animated: true)
            return
        }
        //
        let alert = UIAlertController(
            title: "Save?",
            message: "Would you like to save the banner before exiting?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Don't Save", style: .destructive, handler: { act in
            alert.dismiss(animated: true)
            self.navigationController?.popToRootViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { act in
            self.saveAct()
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    // MARK: - Delete ❌
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
    
    // MARK: - Delete Action ❌
    @objc private func deleteAct(_ sender: MediumButton) {
        
        let alert = UIAlertController(title: "Delete?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { act in
            // find
            guard let model = self.tickerDataModel else { print("Empty"); return }
            // compare id
            let object = self.realm.objects(TickerDataModel.self).where {
                $0._id == model._id
            }.first!
            // delete by id
            try! self.realm.write {
                self.realm.delete(object)
            }
            UIView().hapticNotification(type: .warning)
            self.navigationController?.popToRootViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { act in
            alert.dismiss(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    // MARK: - Play ▶️
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
    // MARK: - play Action ▶️
    @objc private func playAct(_ sender: MediumButton) {
//         + - Работает ⬇️
        if checkPremiumSetting(collectionView: effectSettingsCV) ||
           checkPremiumSetting(collectionView: textSettingsCV) ||
           checkPremiumSetting(collectionView: backgroundSettingsCV) {
            // Открыть Paywall 💰
            let navVC = UINavigationController(rootViewController: PaywallVC())
            navVC.modalPresentationStyle = .overFullScreen
            self.present(navVC, animated: true)
        } else {
            // Открыть Play ▶️
            // push - get current! config + play (work without save)
            EditBannerVC.tickerView.getTickerConfigure { model in
                print("✅ TickerPlayVC get model:",model)
                self.navigationController?.pushViewController(TickerPlayVC(tickerDataModel: model), animated: true)
            }
            UIView().hapticImpact(style: .light)
        }
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
        sv.backgroundColor = AppColors.gray5
        sv.isPagingEnabled = true
        return sv
    }()
    

    // MARK: - Collection View - New ✅
    private let editSettingsVM = EditSettingsVM()
    
    private lazy var effectSettingsCV: EditSettingsCV = {
       let cv = EditSettingsCV(frame: .null, collectionViewLayout: UICollectionViewLayout.init(), editSettingsModel: editSettingsVM.effectSettingsModel)
        return cv
    }()
    
    private lazy var textSettingsCV: EditSettingsCV = {
        let cv = EditSettingsCV(frame: .null, collectionViewLayout: UICollectionViewLayout.init(), editSettingsModel: editSettingsVM.textSettingsModel)
        return cv
    }()
    
    private lazy var backgroundSettingsCV: EditSettingsCV = {
        let cv = EditSettingsCV(frame: .null, collectionViewLayout: UICollectionViewLayout.init(), editSettingsModel: editSettingsVM.backgroundSettingsModel)
        return cv
    }()
    
    
    
    private func manageTextCVData() {
        // идея менять подаваемые данные и управлять textSettingsCV
        
    }
    
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
    
    
    // MARK: - View did load ⚙️
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        // delegate
        setDelegates()
        // UI
        setupUI()
    }
    
    
    // MARK: - view Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        // Default State settings Scroll View
        settingsScrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
        tabBarView.setSelectedItem(tabBarView.items[0], animated: true)
    }

    // MARK: - view Did Layout Subviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.settingsScrollView.setNeedsLayout()
        self.settingsScrollView.layoutIfNeeded()
        setScrollViewUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        EditBannerVC.tickerView.stopSparkleTimer()
    }
    
    
    // MARK: - init ⚙️
    init(tickerDataModel: TickerDataModel?) {
        super.init(nibName: nil, bundle: nil)
        
        print("MODEL - tickerDataModel -", tickerDataModel as Any)
        
        // MARK: - Default select
        setDefaultSelectedSettings(tickerDataModel: tickerDataModel)
        
        // New Banner
        if tickerDataModel == nil {
            self.tickerDataModel = nil
            EditBannerVC.tickerView = TickerView()
            EditBannerVC.tickerView.configTickerLayout(width: self.view.frame.size.width)
            // Хотел configTickerLayout сделать private
        }
        
        // Update Banner
        if let model = tickerDataModel {
            self.tickerDataModel = tickerDataModel
            EditBannerVC.tickerView.configureTicker(tickerDataModel: model, frameBuffer: self.view.frame.size.width)
            self.regularTextField.text = model.inputText
        }
        
        // Track changes
        self.previousSelectedIndex = [
            "effect" : self.effectSettingsCV.selectedEffectIndexPath,
            "text" : self.textSettingsCV.selectedTextIndexPath,
            "background" : self.backgroundSettingsCV.selectedBackgroundIndexPath,
        ]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - deinit 🗑
    deinit {
        print("✅ deinit EditBannerVC")
        EditBannerVC.tickerView = TickerView()
    }
    
    // MARK: - set Default Selected Settings ⚙️
    private func setDefaultSelectedSettings(tickerDataModel: TickerDataModel?) {
        // Select cells by data
        // Default select or cpnfig from realm // Желательно переписать
        // Effect
        if let data = tickerDataModel?.selectedEffectIndexData {
//            print("decoded index ➡️",decodeIndexPath(indexPathData: data) as Any)
            self.effectSettingsCV.selectedEffectIndexPath = decodeIndexPath(indexPathData: data)
            setSelectCV(indexPathArr: decodeIndexPath(indexPathData: data), collection: effectSettingsCV)
        } else {
            let arr: [IndexPath] = [[0, 0],[0, 2],[1, 0],[3, 0],[4, 2]]
            self.effectSettingsCV.selectedEffectIndexPath = arr
            setSelectCV(indexPathArr: arr, collection: effectSettingsCV)
        }
        // Text
        if let data = tickerDataModel?.selectedTextIndexData {
//            print("decoded index ➡️",decodeIndexPath(indexPathData: data) as Any)
            self.textSettingsCV.selectedTextIndexPath = decodeIndexPath(indexPathData: data)
            setSelectCV(indexPathArr: decodeIndexPath(indexPathData: data), collection: textSettingsCV)
        } else {
            let arr: [IndexPath] = [[0, 2], [2, 0], [4, 0], [1, 0], [3, 0]]
            self.textSettingsCV.selectedTextIndexPath = arr
            setSelectCV(indexPathArr: arr, collection: textSettingsCV)
        }
        // Background
        if let data = tickerDataModel?.selectedBackgroundIndexData {
//            print("decoded index ➡️",decodeIndexPath(indexPathData: data) as Any)
            self.backgroundSettingsCV.selectedBackgroundIndexPath = decodeIndexPath(indexPathData: data)
            setSelectCV(indexPathArr: decodeIndexPath(indexPathData: data), collection: backgroundSettingsCV)
        } else {
            let arr: [IndexPath] = [[0, 0], [1, 0]]
            self.backgroundSettingsCV.selectedBackgroundIndexPath = arr
            setSelectCV(indexPathArr: arr, collection: backgroundSettingsCV)
        }
    }
    
    // MARK: - set Select CV
    private func setSelectCV(indexPathArr: [IndexPath], collection: EditSettingsCV) {
        for index in indexPathArr {
            DispatchQueue.main.async {
                collection.selectItem(
                    at: index,
                    animated: true,
                    scrollPosition: [] // must have fix
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
        // Custom Collection View Delegate
        self.effectSettingsCV.customDelegate = self
        self.textSettingsCV.customDelegate = self
        self.backgroundSettingsCV.customDelegate = self
    }
    
}

// MARK: - Delegate text field
extension EditBannerVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard
            textField.text != "",
            let text = textField.text
        else { return }
        EditBannerVC.tickerView.setInputText(text: text)
    }
}



// MARK: - Delegate Tab Bar View
extension EditBannerVC: MDCTabBarViewDelegate {
    func tabBarView(_ tabBarView: MDCTabBarView, didSelect item: UITabBarItem) {
        // Set Content Offset
        if let tag = tabBarView.selectedItem?.tag {
            settingsScrollView.setContentOffset(CGPoint(x: CGFloat(tag) * settingsScrollView.frame.size.width, y: 0), animated: true)
        }
    }
}

// MARK: - Delegate UIScrollView
extension EditBannerVC: UIScrollViewDelegate {
    // scrollViewDidScroll + setSelectedItem работает нормально но!
//    var page: Int {
//        let page = Int(floorf(Float(settingsScrollView.contentOffset.x) / Float(settingsScrollView.frame.size.width)))
//        if page < 0 {
//            return 0
//        } else if page > 2 {
//            return 2
//        } else {
//            return page
//        }
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        print(page)
//        tabBarView.setSelectedItem(tabBarView.items[page], animated: true)
       
// MARK: - переключать tabBarView по свайпу Нуждается в доработке!
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        print("ScrollingAnimation")
//        print("Page offset --- \(page)")
//        print("DidEndScrollingAnimation - ✅ - ",scrollView.contentOffset)
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
        
        let viewMargin = self.view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            
            EditBannerVC.tickerView.heightAnchor.constraint(equalToConstant: 160),

            contentStack.topAnchor.constraint(equalTo: viewMargin.topAnchor, constant: top),
            contentStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: left),
            contentStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: right),

            bottomStack.topAnchor.constraint(equalTo: contentStack.bottomAnchor, constant: 32),
            bottomStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bottomStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bottomStack.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    // MARK: - Settings Scroll View UI
    func setScrollViewUI() {
        // Так себе конфиг c self.view
        settingsScrollView.contentSize = CGSize(
            width: view.frame.size.width*3,
            height: settingsScrollView.frame.size.height
        )
        
        for page in 0..<3 {
            // Effect
            if page == 0 {
                effectSettingsCV.frame = CGRect(
                    x: CGFloat(page) * self.view.frame.size.width,
                    y: 0,
                    width: self.view.frame.size.width,
                    height: settingsScrollView.frame.size.height
                )
                settingsScrollView.addSubview(effectSettingsCV)
            }
            // Text
            if page == 1 {
                textSettingsCV.frame = CGRect(
                    x: CGFloat(page) * self.view.frame.size.width,
                    y: 0,
                    width: self.view.frame.size.width,
                    height: settingsScrollView.frame.size.height
                )
                settingsScrollView.addSubview(textSettingsCV)
            }
            // background
            if page == 2 {
                backgroundSettingsCV.frame = CGRect(
                    x: CGFloat(page) * self.view.frame.size.width,
                    y: 0,
                    width: self.view.frame.size.width,
                    height: settingsScrollView.frame.size.height
                )
                settingsScrollView.addSubview(backgroundSettingsCV)
            }
        }
    }
}

// MARK: - Custom Collection View Delegate
extension EditBannerVC: CustomCollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let collection = collectionView as? EditSettingsCV
        let type = collection?.editSettingsModel.editSettingsModelType
        let title = collection?.editSettingsModel.sections[indexPath.section].sectionTitle
        
        // 🔍 Find selected IndexPath in specific section.
        let shadow_v2 = findSelectedIndexPath_v2(editSettingsCV: self.textSettingsCV, type: .text, sectionTitle: "Shadow")
        
        
        
        if title == "General" {
            setSelectCV(indexPathArr: [IndexPath(row: 0, section: 4)], collection: self.textSettingsCV)
//            if let shadow_v2 = shadow_v2 {
//                setSelectCV(indexPathArr: [IndexPath(row: 0, section: 4)], collection: self.textSettingsCV)
//            }
        }
        
        
    }
    
    // MARK: - Logic for switching use cases the selection of settings
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let collection = collectionView as? EditSettingsCV
        let type = collection?.editSettingsModel.editSettingsModelType
        let title = collection?.editSettingsModel.sections[indexPath.section].sectionTitle
        
        // 🔍 Find selected IndexPath in specific section.
        // Effect
        let led = findSelectedIndexPath(editSettingsCV: self.effectSettingsCV, type: .effect, sectionTitle: "LED")
        let pixel = findSelectedIndexPath(editSettingsCV: self.effectSettingsCV, type: .effect, sectionTitle: "Pixel")
        // Text v2
        let led_v2 = findSelectedIndexPath_v2(editSettingsCV: self.effectSettingsCV, type: .effect, sectionTitle: "LED")
        let fonts_v2 = findSelectedIndexPath_v2(editSettingsCV: self.textSettingsCV, type: .text, sectionTitle: "Fonts")
        let size_v2 = findSelectedIndexPath_v2(editSettingsCV: self.textSettingsCV, type: .text, sectionTitle: "Size")
        let shadow_v2 = findSelectedIndexPath_v2(editSettingsCV: self.textSettingsCV, type: .text, sectionTitle: "Shadow")
        // background
        let image_v2 = findSelectedIndexPath_v2(editSettingsCV: self.backgroundSettingsCV, type: .text, sectionTitle: "Image")
        let color_v2 = findSelectedIndexPath_v2(editSettingsCV: self.backgroundSettingsCV, type: .text, sectionTitle: "Color")
        
        
        // Определяем из какой секции был выбран indexPath
        switch type {
        case .effect:
            if title == "LED" && indexPath == IndexPath(row: 0, section: 1) {
                deactivateLED()
            } else if title == "LED" {
                // Выбор формы пикселя
                // select defauld - Pixel
                if pixel == nil {
                    setSelectCV(indexPathArr: [IndexPath(row: 0, section: 2)], collection: self.effectSettingsCV)
                }
                
                // deselect fonts, size
                deactivateFontAndSize()
            } else if title == "Pixel" {
                deactivateFontAndSize()
                // первым был выбран Pixel
                if led == IndexPath(row: 0, section: 1) {
                    setSelectCV(indexPathArr: [IndexPath(row: 1, section: 1)], collection: self.effectSettingsCV)
                    if let led = led {
                        self.effectSettingsCV.deselectItem(at: led, animated: true)
                    }
                }
            }
            
            
            if title == "General" {
                if let shadow_v2 = shadow_v2 {
                    self.textSettingsCV.deselectItem(at: shadow_v2, animated: true)
                }
            }
            
            print("✅ NEW effect SELECT", title as Any, indexPath)
        case .text:
            
            if title == "Fonts" { // title == "Size" ||
                
                if let led_v2 = led_v2 {
                    self.effectSettingsCV.deselectItem(at: led_v2, animated: true)
                }
                // findSelectedIndexPath_v2 правильнее т.к сразу получаем selects, а не через переменную
                if let pixel_v2 = findSelectedIndexPath_v2(editSettingsCV: self.effectSettingsCV, type: .effect, sectionTitle: "Pixel") {
                    self.effectSettingsCV.deselectItem(at: pixel_v2, animated: true)
                }
                setSelectCV(indexPathArr: [IndexPath(row: 0, section: 1)], collection: self.effectSettingsCV)
                deactivateLED()
            }
            
            
            if title == "Shadow" {
                self.effectSettingsCV.deselectItem(at: IndexPath(row: 3, section: 0), animated: true)
            }
            
            
            
            print("✅ NEW text SELECT", title as Any, indexPath)
        case .background:
            
//            color_v2
            
            if title == "Color" {
                guard let image_v2 = image_v2 else { return }
                self.backgroundSettingsCV.deselectItem(at: image_v2, animated: true)
                setSelectCV(indexPathArr: [IndexPath(row: 0, section: 1)], collection: self.backgroundSettingsCV)
            }
            
//            if image_v2 != IndexPath(row: 0, section: 1) {
//
//            }
            
            
            
            print("✅ NEW background SELECT", title as Any, indexPath)
        case .none: break;
        }
        
//        func activateLED() {
//
//        }
        
        func deactivateLED() {
            
            if fonts_v2 == nil {
                setSelectCV(indexPathArr: [IndexPath(row: 0, section: 1)], collection: textSettingsCV)
            }
            if size_v2 == nil {
                setSelectCV(indexPathArr: [IndexPath(row: 4, section: 0)], collection: textSettingsCV)
            }
            self.effectSettingsCV.resetAxisValues()
            // deselect pixel
            if let pixel = pixel {
                self.effectSettingsCV.deselectItem(at: pixel, animated: true)
            }
        }
        
        func deactivateFontAndSize() {
            if let fonts_v2 = fonts_v2 {
                self.textSettingsCV.deselectItem(at: fonts_v2, animated: true)
            }
//            if let size_v2 = size_v2 {
//                self.textSettingsCV.deselectItem(at: size_v2, animated: true)
//            }
        }
        
    }
}
