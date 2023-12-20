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
    // MARK: - Save Act ✅
    @objc private func saveAct() {
        
        // get selected indexPath from CV as Data
        let effectData = encodeIndexPath(indexPathArr: effectSettingsCV.selectedEffectIndexPath)
        let textData = encodeIndexPath(indexPathArr: textSettingsCV.selectedTextIndexPath)
        let backgroundData = encodeIndexPath(indexPathArr: backgroundSettingsCV.selectedBackgroundIndexPath)
        
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
                    // можно заменитть на effectData
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
            print("Save",model)
            // Update - Set new
            try! self.realm.write {
                //
                object.inputText = model.inputText
                object.textColor = model.textColor
                object.textSpeed = model.textSpeed
                object.bgColor = model.bgColor
                object.fontName = model.fontName
                object.fontSize = model.fontSize
                object.stroke = model.stroke
                object.shadow = model.shadow
                object.bgImage = model.bgImage
                //
                object.selectedEffectIndexData = newEffectData
                object.selectedTextIndexData = newTextData
                object.selectedBackgroundIndexData = newBackgroundData
            }
        }
        self.requestReview()
        UIView().hapticNotification(type: .success)
        self.navigationController?.popToRootViewController(animated: true)
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
        
        
//        let selectedEffectIndexPath = effectSettingsCV.selectedEffectIndexPath
//        let selected2 = textSettingsCV.selectedTextIndexPath
//        let selected3 = backgroundSettingsCV.selectedBackgroundIndexPath
//        print("🟠 NEW selectedEffectIndexPath -",selectedEffectIndexPath)
//        print("🟠 NEW selected2 -",selected2)
//        print("🟠 NEW selected3 -",selected3)
//        print("🟢 previousSelectedIndex -",previousSelectedIndex)
        

//        print("🟠 effect -", previousSelectedIndex?["effect"] != effectSettingsCV.selectedEffectIndexPath)
//        print("🟠 text -", previousSelectedIndex?["text"] != textSettingsCV.selectedTextIndexPath)
//        print("🟠 background -", previousSelectedIndex?["background"] != backgroundSettingsCV.selectedBackgroundIndexPath)
        
        
        
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
//        print("effectSettingsCV",effectSettingsCV.selectedEffectIndexPath)
//        print("textSettingsCV",textSettingsCV.selectedTextIndexPath)
//        print("backgroundSettingsCV",backgroundSettingsCV.selectedBackgroundIndexPath)
        
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
    
    // Text Settings Model
    lazy var managedTextSettingsModel: EditSettingsModel = {
       let model = editSettingsVM.textSettingsModel
        return model
    }() {
        didSet {
            print("🟠", managedTextSettingsModel.sections.count)
            self.textSettingsCV.reloadData()
        }
    }
    
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
    
    
    
    
    
    // MARK: - Collection View - OLD
    // // поправить ?! на 1 экземпляр
//    private let effectSettingsCV = EditSettingsCV(frame: .null, collectionViewLayout: UICollectionViewLayout.init(), editSettingsModel: EditSettingsVM().effectSettingsModel) // <-------
//
//    private let textSettingsCV = EditSettingsCV(frame: .null, collectionViewLayout: UICollectionViewLayout.init(), editSettingsModel: EditSettingsVM().textSettingsModel) // <-------
//
//    private let backgroundSettingsCV = EditSettingsCV(frame: .null, collectionViewLayout: UICollectionViewLayout.init(), editSettingsModel: EditSettingsVM().backgroundSettingsModel) // <-------

    
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
    
    
    
    // MARK: - init ⚙️
    init(tickerDataModel: TickerDataModel?) {
        super.init(nibName: nil, bundle: nil)
        
        print("MODEL - tickerDataModel -", tickerDataModel as Any)
        
        // Select cells by data
//        print("init EditBannerVC get decoded ➡️")
        
        
        // MARK: - Default select
        setDefaultSelectedSettings()
        
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
    
    // MARK: - deinit
    deinit {
        EditBannerVC.tickerView = TickerView()
    }
    
    // MARK: - set Default Selected Settings
    private func setDefaultSelectedSettings() {
        // Default select or cpnfig from realm
        // Effect
        if let data = tickerDataModel?.selectedEffectIndexData {
//            print("decoded index ➡️",decodeIndexPath(indexPathData: data) as Any)
            self.effectSettingsCV.selectedEffectIndexPath = decodeIndexPath(indexPathData: data)
            setSelectCV(indexPathArr: decodeIndexPath(indexPathData: data), collection: effectSettingsCV)
        } else {
            let arr: [IndexPath] = [] // [0, 0] [1, 2]
            self.effectSettingsCV.selectedEffectIndexPath = arr
            setSelectCV(indexPathArr: arr, collection: effectSettingsCV)
        }
        // Text
        if let data = tickerDataModel?.selectedTextIndexData {
//            print("decoded index ➡️",decodeIndexPath(indexPathData: data) as Any)
            self.textSettingsCV.selectedTextIndexPath = decodeIndexPath(indexPathData: data)
            setSelectCV(indexPathArr: decodeIndexPath(indexPathData: data), collection: textSettingsCV)
        } else {
            let arr: [IndexPath] = [[0, 0], [2, 0], [4, 0], [1, 0], [3, 0]]
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
//        let width: CGFloat = right - left
        
        let viewMargin = self.view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            
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
    
    // MARK: - Settings Scroll View UI
    
    func setScrollViewUI() {
       
        // MARK: -  🔴 Баг с ContentOffset при инициализации
        
//        print("✅",textSettingsCV.contentOffset)
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

// MARK: - Custom Collection View Delegate 🟢
extension EditBannerVC: CustomCollectionViewDelegate {
    
    
    

    
    
    
    // Custom Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Получить все выбранные секции из 3-х коллекций по любому didSelect
        // Reselect existing selected rows after reloadData() по косвенному индексу .sectionTitle == 
//        print("✅ NEW SELECT", indexPath)
        
        let collection = collectionView as? EditSettingsCV
        let type = collection?.editSettingsModel.editSettingsModelType
        let title = collection?.editSettingsModel.sections[indexPath.section].sectionTitle
        
        
        print("🟣",collection?.selectedEffectIndexPath)
        print("🟣",collection?.selectedTextIndexPath)
        print("🟣",collection?.selectedBackgroundIndexPath)
        
        // Определяем из какой секции был выбран indexPath
        switch type {
        case .effect:
            // при reloadData() происходит Deselect всех секций в Collection
            if title == "LED" && indexPath == IndexPath(row: 0, section: 1) {
                self.textSettingsCV.returnTextSettingsModel(editSettingsModel: self.editSettingsVM.textSettingsModel)
                self.effectSettingsCV.removePixelSetting()
            } else if title == "LED" {
                self.effectSettingsCV.addPixelSetting(editSettingsModel: self.editSettingsVM.effectSettingsModel)
                self.textSettingsCV.removeFontsSection()
                self.textSettingsCV.removeSizeSection()
            }
            print("✅ NEW SELECT", title as Any, indexPath)
        case .text:
            print("✅ NEW SELECT", title as Any, indexPath)
        case .background:
            print("✅ NEW SELECT", title as Any, indexPath)
        case .none:
            break
        }
        
        // Определяем из какой секции был выбран indexPath
//        if cv?.editSettingsModel.editSettingsModelType == .effect {
//            let title = cv?.editSettingsModel.sections[indexPath.section].sectionTitle
//            print("✅ NEW SELECT", title, indexPath)
//        }
        
//        self.textSettingsCV.removeFontsSection()
        
//        let led = findSelectedIndexPath(editSettingsCV: self.effectSettingsCV, type: .effect, sectionTitle: "LED")
//
//        print("🔴",self.effectSettingsCV.selectedEffectIndexPath)
        
        
//        if editSettingsModel.editSettingsModelType == .text
        
//        if self.effectSettingsCV.editSettingsModel.editSettingsModelType == .effect {
//            let findSelectSection = self.effectSettingsCV.editSettingsModel.sections[indexPath.section] // скорее всего выдает ошибку потому что такого массива вообще нет
//            let findSelectItem = findSelectSection.sectionCells[indexPath.row]
//
//
//            if findSelectSection.sectionTitle == "LED" {
//                print("🟢 find",indexPath)
//    //            findSelectSection.sectionCells
//    //            switch findSelectItem {
//    //            case .regularCell(model: let model):
//    //
//    //            }
//
//                // 🤯
//                if indexPath == IndexPath(row: 0, section: 0) {
//                    print("HD")
//                    // 1. Блокировать Text collectionView + Добавить замок в String
//                    // 2. Добавлять в Effect model Цвет, pixel,
//                    // И убирать при выборе IndexPath(row: 0, section: 0)
//                    self.textSettingsCV.unlockCollectionUI()
//                } else {
//                    self.textSettingsCV.lockCollectionUI()
//                }
//
//            }
//        }
        
        
        
        
        
//        indexPath
        
        
        
//        if led != nil, led != editSettingsCV.selectedEffectIndexPath {
//
//        }
        
//        if let size = size {
//            self.textSettingsCV.cellForItem(at: size)?.isUserInteractionEnabled = false
//            self.textSettingsCV.deselectItem(at: size, animated: true)
//            self.textSettingsCV.cellForItem(at: size)?.isUserInteractionEnabled = false
//        }
        
        
//        print("1🔴",self.editSettingsVM.textSettingsModel.sections.count)
//        
//        // берем из VM образец данных исключаем "Fonts"
//        let newTextSections = self.editSettingsVM.textSettingsModel.sections.filter { editSettingsSection in
//            editSettingsSection.sectionTitle != "Fonts"
//        }
//        print("2🔴",newTextSections.count)
//        let newTextSettingsModel = EditSettingsModel(editSettingsModelType: .text, sections: newTextSections)
//        self.managedTextSettingsModel = newTextSettingsModel

        
//        self.textSettingsCV.reloadData()
        
        
        // найти indexPath внутри section в коллекции по sectionTitle ☑️
        // функция которая возвращает массив IndexPath конкретной секции sectionTitle ☑️
        
        // Идея прятать sections при выборе в Led
        
//        let led = findSelectedIndexPath(editSettingsCV: self.effectSettingsCV, type: .effect, sectionTitle: "LED")
//        let fonts = findSelectedIndexPath(editSettingsCV: self.textSettingsCV, type: .text, sectionTitle: "Fonts")
//        let size = findSelectedIndexPath(editSettingsCV: self.textSettingsCV, type: .text, sectionTitle: "Size")

        
//        self.textSettingsCV.cellForItem(at: size)?.isUserInteractionEnabled = false
        
//        self.selectedEffectIndexPath.forEach { selectedIndexPath in
//        }
        
        
        
        
            
//        let indexSet = IndexSet(arrayLiteral: 0)
//        self.textSettingsCV.performBatchUpdates({
//            self.textSettingsCV.deleteSections(indexSet)
//        }, completion: nil)
        
        
//            .first { selectedIndexPath in
//            let section = editSettingsCV.editSettingsModel.sections[selectedIndexPath.section]
//            return section.sectionTitle == sectionTitle
//        }
        
        
        
//        print("🔴 first", first)
//        print("🔴 second", second)
        
        // deselect не очень хорошо работает
//        if led != nil {

//            if let fonts = fonts {
//                self.textSettingsCV.deselectItem(at: fonts, animated: true)
//            }
            
//            if let size = size {
//                self.textSettingsCV.cellForItem(at: size)?.isUserInteractionEnabled = false
//                self.textSettingsCV.deselectItem(at: size, animated: true)
//                self.textSettingsCV.cellForItem(at: size)?.isUserInteractionEnabled = false
//            }
//        }
        
//        self.effectSettingsCV.section
//
        
//        self.textSettingsCV.cell
        
//        collectionView.ce
        
        
        
        
//        collectionView.selectedTextIndexPath.forEach { selectedIndexPath in
////            selectedIndexPath
//        }
        
//        let result = collectionView.selectedTextIndexPath.first { selectedIndexPath in
//            let section = collectionView.editSettingsModel.sections[selectedIndexPath.section]
////            return section.sectionTitle == sectionTitle
//            if section.sectionTitle == sectionTitle {
//
////                editSettingsCV.editSettingsModel.sections.remove(at: indexPath.section)
//            }
//        }
        
        
        
        
    }
    
//    private func findSelectedIndexPath(editSettingsCV: EditSettingsCV, type: EditSettingsModelType, sectionTitle: String) -> IndexPath? {
//
//        switch type {
//        case .effect:
//            let result = editSettingsCV.selectedEffectIndexPath.first { selectedIndexPath in
//                let section = editSettingsCV.editSettingsModel.sections[selectedIndexPath.section]
//                return section.sectionTitle == sectionTitle
//            }
//            print("Find \(sectionTitle) 🟣", result as Any)
//            return result
//        case .text:
//            let result = editSettingsCV.selectedTextIndexPath.first { selectedIndexPath in
//                let section = editSettingsCV.editSettingsModel.sections[selectedIndexPath.section]
//                return section.sectionTitle == sectionTitle
//            }
//            print("Find \(sectionTitle) 🟣", result as Any)
//            return result
//        case .background:
//            let result = editSettingsCV.selectedBackgroundIndexPath.first { selectedIndexPath in
//                let section = editSettingsCV.editSettingsModel.sections[selectedIndexPath.section]
//                return section.sectionTitle == sectionTitle
//            }
//            print("Find \(sectionTitle) 🟣", result as Any)
//            return result
//        }
//    }
    
    
    
}
