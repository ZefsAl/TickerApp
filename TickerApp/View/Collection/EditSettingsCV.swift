//
//  EditSettingsCV.swift
//  TickerApp
//
//  Created by Serj on 06.10.2023.
//

import UIKit

protocol CustomCollectionViewDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
}

final class EditSettingsCV: UICollectionView {
    
    weak var customDelegate: CustomCollectionViewDelegate?
    
    var editSettingsModel: EditSettingsModel
    
    private var axisValueModel = AxisValueModel()
    
    
    // MARK: - Selected
    var selectedEffectIndexPath: [IndexPath] = [] {
        didSet {
            print("🔵 Effect Settings == \(selectedEffectIndexPath)")
        }
    }
    var selectedTextIndexPath: [IndexPath] = [] {
        didSet {
            print("🔵 Text Settings == \(selectedTextIndexPath)")
        }
    }
    var selectedBackgroundIndexPath: [IndexPath] = [] {
        didSet {
            print("🔵 Backgroun Settings == \(selectedBackgroundIndexPath)")
        }
    }
    
    
    // MARK: - init ⚙️
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, editSettingsModel: EditSettingsModel) {
        
        self.editSettingsModel = editSettingsModel
        super.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        registerCell()
        
        self.backgroundColor = .clear
        self.alwaysBounceVertical = true
        self.showsVerticalScrollIndicator = false
        
        setCompositionalLayoutCV()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Layout
    private func setCompositionalLayoutCV() {
        // Compositional Layout
        let collectionViewLayout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, environment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            let section = self.editSettingsModel.sections[sectionIndex]
            // Должны вернуть NSCollectionLayoutSection для конкретной секции
            return self.setSectionLayout(sectionItems: section.sectionCells, environment: environment)
        }
        // Collection View
        self.collectionViewLayout = collectionViewLayout
    }
    // set Section Layout
    private func setSectionLayout(sectionItems: [CellSectionType], environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        // layout Item + Size
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(50),
            heightDimension: .absolute(50)
        )
        let items: [NSCollectionLayoutItem] = sectionItems.map({ _ in
                .init(layoutSize: itemSize)
        })
        // ~ Group ~ size
        let groupEstimateSize = CGSize(width: 250, height: 50)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(groupEstimateSize.width),
            heightDimension: .estimated(groupEstimateSize.height)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: items)
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.boundarySupplementaryItems = [headerItem]
        section.supplementariesFollowContentInsets = false
        
        return section
    }
    // headerItem + used data source
    private var headerItem: NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50)
        )
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
    }
    
    
    // MARK: - Setup Cell
    private func registerCell() {
        self.delegate = self
        self.dataSource = self
        // Header
        self.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseID)
        // Cell
        self.register(EditSettingCVCell.self, forCellWithReuseIdentifier: EditSettingCVCell.reuseID)
        // Selection
        self.allowsMultipleSelection = true
    }
}

// MARK: - Axis Values
extension EditSettingsCV {
    public func resetAxisValues() {
        self.axisValueModel.axisValue = AxisValueModel().axisValue
    }
}

// MARK: - Data Source
extension EditSettingsCV: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.editSettingsModel.sections.count
    }
    
    // Items In Section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.editSettingsModel.sections[section].sectionCells.count
    }
    
    // - cell For Item At
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let section = self.editSettingsModel.sections[indexPath.section]
        let cellItem = section.sectionCells[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditSettingCVCell.reuseID, for: indexPath) as? EditSettingCVCell
        
        switch cellItem.self {
        case .regularCell(let model):
            cell?.configure(model: model)
            return cell ?? UICollectionViewCell()
        }
    }
    
    //  Supplementary Element
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let title = self.editSettingsModel.sections[indexPath.section].sectionTitle
        
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseID, for: indexPath) as? SectionHeaderView
        sectionHeader?.label.text = title
        sectionHeader?.label.font = SFProRounded.set(fontSize: 14, weight: .semibold)
        return sectionHeader ?? UICollectionReusableView()
    }
    
}


// MARK: - Delegate
extension EditSettingsCV: UICollectionViewDelegate {
    
    // Did Deselect
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if editSettingsModel.editSettingsModelType == .effect {
            getSelectedSettings_v2(selectedSettings: selectedEffectIndexPath, compareWith: "General") { model in
                switch indexPath {
                case IndexPath(row: 0, section: 0):
                    EditBannerVC.tickerView.setStroke(widthStr: "0")
                case IndexPath(row: 1, section: 0):
                    EditBannerVC.tickerView.reverseScroll(isReversedScroll: false)
                case IndexPath(row: 2, section: 0):
                    EditBannerVC.tickerView.setShadow(radiusStr: "0")
                default: break
                }
            }
        }
        
        // Custom Delegate - after all actions
        self.customDelegate?.collectionView(collectionView, didDeselectItemAt: indexPath)
    }
    
    // Did Select
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // По хорошему didSelectItemAt переписать на switch
        let led_v2 = findSelectedIndexPath_v2(editSettingsCV: self, type: .effect, sectionTitle: "LED")
        // 🔍 Find in Specific self CV
        // text
        let size_v2 = findSelectedIndexPath_v2(editSettingsCV: self, type: .text, sectionTitle: "Size")
        let fonts_v2 = findSelectedIndexPath_v2(editSettingsCV: self, type: .text, sectionTitle: "Fonts")
        
        // background
        let image_v2 = findSelectedIndexPath_v2(editSettingsCV: self, type: .text, sectionTitle: "Image")
        let color_v2 = findSelectedIndexPath_v2(editSettingsCV: self, type: .text, sectionTitle: "Color")
        
        
        
        // Select only one row in section
        if let selectedIndexPaths = collectionView.indexPathsForSelectedItems?.filter({ indexPath in
            let section = editSettingsModel.sections[indexPath.section]
            return section.sectionTitle != "General"
        }) {
            for selectedIndex in selectedIndexPaths {
                if (indexPath.section == selectedIndex.section) && (indexPath.row != selectedIndex.row) {
                    // только при переключении в контексте конкретной секции и колекции
                    collectionView.deselectItem(at: selectedIndex, animated: true)
                }
            }
        }
        
        
        // Set Settings
        // MARK: - Effect
        if editSettingsModel.editSettingsModelType == .effect {
            guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems else { return }
            selectedEffectIndexPath = selectedIndexPaths
            
            getSelectedSettings_v2(selectedSettings: selectedEffectIndexPath, compareWith: "General") { model in
                switch indexPath {
                case IndexPath(row: 0, section: 0):
                    // Bold
                    if led_v2 == IndexPath(row: 0, section: 1) {
                        EditBannerVC.tickerView.setStroke(widthStr: "2")
                    }
                case IndexPath(row: 1, section: 0):
                    // Reverse
                    EditBannerVC.tickerView.reverseScroll(isReversedScroll: true)
                case IndexPath(row: 2, section: 0):
                    // Glow
                    EditBannerVC.tickerView.setShadow(radiusStr: "5")
                default: break
                }
            }
            
            
            // Sparkle
            getSelectedSettings_v2(selectedSettings: selectedEffectIndexPath, compareWith: "Sparkle") { model in
                guard
                    let infoMessage = model.infoMessage,
                    let duration = Double(infoMessage)
                else { return }
                EditBannerVC.tickerView.startSparkleTimer(duration: duration)
            }
            
            // LED
            getSelectedSettings_v2(selectedSettings: selectedEffectIndexPath, compareWith: "LED") { model in
                guard let shape: String = model.infoMessage else {
                    if indexPath == IndexPath(row: 0, section: 1) {
                        EditBannerVC.tickerView.setDefaultFont()
                    }
                    return
                }
                self.axisValueModel.axisValue[1162629960] = Float(shape)
                EditBannerVC.tickerView.setHandjetFont(
                    variableFont: .fontHandjet(EditBannerVC.tickerView.currentFontSize, axis: self.axisValueModel.axisValue)
                )
                
            }
            
            // Pixel
            getSelectedSettings_v2(selectedSettings: selectedEffectIndexPath, compareWith: "Pixel") { model in
                if indexPath != IndexPath(row: 0, section: 1) {
                    if let grid = model.title {
                        self.axisValueModel.axisValue[1162626898] = Float(grid)
                        EditBannerVC.tickerView.setHandjetFont(
                            variableFont: .fontHandjet(EditBannerVC.tickerView.currentFontSize, axis: self.axisValueModel.axisValue)
                        )
                    }
                }
            }
            
            // Scroll Speed
            getSelectedSettings_v2(selectedSettings: selectedEffectIndexPath, compareWith: "Scroll Speed") { model in
                EditBannerVC.tickerView.setTextSpeed(speedStr: model.title)
            }
        }
        
        // MARK: - Text
        // Добавляем выбранные indexPathsForSelectedItems в отдельный массив
        if editSettingsModel.editSettingsModelType == .text {
            guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems else { return }
            selectedTextIndexPath = selectedIndexPaths
            // Применяем Text select
            
            // Size
            getSelectedSettings_v2(selectedSettings: selectedTextIndexPath, compareWith: "Size") { model in
//                if fonts_v2 == nil {
//                    EditBannerVC.tickerView.setDefaultFont()
//                }
                guard let title = model.title else { return }
                EditBannerVC.tickerView.setFontSize(stringSize: title)
            }
            
            // Font
            getSelectedSettings_v2(selectedSettings: selectedTextIndexPath, compareWith: "Fonts") { model in
                if size_v2 == nil {
                    EditBannerVC.tickerView.setDefaultFont()
                }
                guard let fontName = model.fontName else { return }
                EditBannerVC.tickerView.setFont(fontName: fontName)
            }
            
            // Color
            getSelectedSettings_v2(selectedSettings: selectedTextIndexPath, compareWith: "Color") { model in
                EditBannerVC.tickerView.setTextColor(color: model.bgColor)
            }
            
            // Stroke
            getSelectedSettings_v2(selectedSettings: selectedTextIndexPath, compareWith: "Stroke") { model in
                EditBannerVC.tickerView.setStroke(widthStr: model.infoMessage)
            }
            
            // Shadow
            getSelectedSettings_v2(selectedSettings: selectedTextIndexPath, compareWith: "Shadow") { model in
                EditBannerVC.tickerView.setShadow(radiusStr: model.infoMessage)
            }
        }
        
        // MARK: - Background
        if editSettingsModel.editSettingsModelType == .background {
            guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems else { return }
            selectedBackgroundIndexPath = selectedIndexPaths
            
            // Color
            getSelectedSettings_v2(selectedSettings: selectedBackgroundIndexPath, compareWith: "Color") { model in
                EditBannerVC.tickerView.setBGColor(bgColor: model.bgColor)
            }
            // Image
            getSelectedSettings_v2(selectedSettings: selectedBackgroundIndexPath, compareWith: "Image") { model in
                EditBannerVC.tickerView.setBackgroundImage(named: model.bgImageName)
            }
        }
        
        
        // Custom Delegate - after all actions
        self.customDelegate?.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    
    // MARK: - get Selected Settings
    private func getSelectedSettings_v2(selectedSettings: [IndexPath], compareWith: String, handler: @escaping (RegularCellModel) -> Void ) {
        
        for selectedIndex in selectedSettings {
            let section = editSettingsModel.sections[selectedIndex.section]
            let cells = section.sectionCells[selectedIndex.row]
            
            if section.sectionTitle == compareWith {
                switch cells.self {
                case .regularCell(let model):
                    handler(model)
                }
            }
        }
    }
}
