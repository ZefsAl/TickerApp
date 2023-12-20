//
//  EditSettingsCV.swift
//  TickerApp
//
//  Created by Serj on 06.10.2023.
//

import UIKit

protocol CustomCollectionViewDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
//    func numberOfSections(in collectionView: UICollectionView) -> Int
}

final class EditSettingsCV: UICollectionView {

    weak var customDelegate: CustomCollectionViewDelegate?
    
    var editSettingsModel: EditSettingsModel 
    
    private var axisValue: [Int:Float] = [
        2003265652 : 330, // wght
        1162629960 : 2, // ELSH
        1162626898 : 1 // ELGR
    ]
    
    private var lockingOverlayView: LockingOverlayView = LockingOverlayView()
    

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
    
    
    
    // MARK: - init
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, editSettingsModel: EditSettingsModel) {
        
        self.editSettingsModel = editSettingsModel
        super.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        registerCell()
        
        self.backgroundColor = .clear
        self.alwaysBounceVertical = true
        self.showsVerticalScrollIndicator = false
        
        setCompositionalLayoutCV()
        removePixelSetting()
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
    //
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



// MARK: - Data Source
extension EditSettingsCV: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("numberOfSections🟠",self.editSettingsModel.sections.count)
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
    
    private func reselectCells() {
//        self.selectedTextIndexPath
    }
    
    // Did Select Item At
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Select only one row in section
        if let selectedIndexPaths = collectionView.indexPathsForSelectedItems {
            for selectedIndex in selectedIndexPaths {
                if (indexPath.section == selectedIndex.section) && (indexPath.row != selectedIndex.row) {
                    // только при переключении в контексте конкретной секции и колекции
                    collectionView.deselectItem(at: selectedIndex, animated: true)
                }
            }
        }
        
        
        
        // MARK: - Set Settings
        //  Effect
        if editSettingsModel.editSettingsModelType == .effect {
            guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems else { return }
            selectedEffectIndexPath = selectedIndexPaths
            
            // LED
            getSelectedSettings_v2(selectedSettings: selectedEffectIndexPath, compareWith: "LED") { model in
                // Shape
                if let number = model.infoMessage {
                    self.axisValue[1162629960] = Float(number)
                    EditBannerVC.tickerView.setHandjetFont(
                        variableFont: .fontHandjet(150, axis: self.axisValue)
                    )
                }
            }
            
            // Pixel
            getSelectedSettings_v2(selectedSettings: selectedEffectIndexPath, compareWith: "Pixel") { model in
                // Grid
                if let grid = model.title {
                    self.axisValue[1162626898] = Float(grid)
                    EditBannerVC.tickerView.setHandjetFont(
                        variableFont: .fontHandjet(150, axis: self.axisValue)
                    )
                }
            }
            
            // Speed
            getSelectedSettings_v2(selectedSettings: selectedEffectIndexPath, compareWith: "Scroll Speed") { model in
                EditBannerVC.tickerView.setTextSpeed(speedStr: model.title)
            }
        }
        
        // Text
        // Добавляем выбранные indexPathsForSelectedItems в отдельный массив
        if editSettingsModel.editSettingsModelType == .text {
            guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems else { return }
            selectedTextIndexPath = selectedIndexPaths
            // Применяем Text select
            
            // Size
            getSelectedSettings_v2(selectedSettings: selectedTextIndexPath, compareWith: "Size") { model in
                EditBannerVC.tickerView.setFontSize(stringSize: model.title)
            }
            
            // Font
            getSelectedSettings_v2(selectedSettings: selectedTextIndexPath, compareWith: "Fonts") { model in
                guard let fontName = model.fontName else { return }
                EditBannerVC.tickerView.setFont(fontName: fontName)
            }
            
            // Color
            getSelectedSettings_v2(selectedSettings: selectedTextIndexPath, compareWith: "Color") { model in
                EditBannerVC.tickerView.setTextColor(color: model.bgColor)
            }
            
            // Stroke
            getSelectedSettings_v2(selectedSettings: selectedTextIndexPath, compareWith: "Stroke") { model in
                EditBannerVC.tickerView.setStroke(widthStr: model.title)
            }
            
            // Stroke
            getSelectedSettings_v2(selectedSettings: selectedTextIndexPath, compareWith: "Shadow") { model in
                EditBannerVC.tickerView.setShadow(radiusStr: model.title)
                
            }
            
            
        }
        
        //  Background
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
    
//    private func deselectLEDorFont() {
        
//        for selectedIndex in selectedSettings {
//            let section = editSettingsModel.sections[selectedIndex.section]
//            let cells = section.sectionCells[selectedIndex.row]
//
//
//            if section.sectionTitle == "LED"
//
//
////            if section.sectionTitle == compareWith {
////                switch cells.self {
////                case .regularCell(let model):
////                    handler(model)
////                }
////            }
//        }
        
        
//    }
    
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



// Data manage
extension EditSettingsCV {
    
    // По хорошему Manager нужен 
    func removeSizeSection() {
        guard editSettingsModel.editSettingsModelType == .text else { return }
        // берем из VM образец данных исключаем "Fonts"
        let newTextSections = self.editSettingsModel.sections.filter { editSettingsSection in
            editSettingsSection.sectionTitle != "Size"
        }
        let newTextSettingsModel = EditSettingsModel(editSettingsModelType: .text, sections: newTextSections)
        self.editSettingsModel = newTextSettingsModel
        self.reloadData()
    }
    
    // +- работает
    func removeFontsSection() {
        guard editSettingsModel.editSettingsModelType == .text else { return }
        // берем из VM образец данных исключаем "Fonts"
        let newTextSections = self.editSettingsModel.sections.filter { editSettingsSection in
            editSettingsSection.sectionTitle != "Fonts"
        }
        let newTextSettingsModel = EditSettingsModel(editSettingsModelType: .text, sections: newTextSections)
        self.editSettingsModel = newTextSettingsModel
        self.reloadData()
    }
    
    func removePixelSetting() {
        guard editSettingsModel.editSettingsModelType == .effect else { return }
        let newTextSections = self.editSettingsModel.sections.filter { editSettingsSection in
            editSettingsSection.sectionTitle != "Pixel"
        }
        let newTextSettingsModel = EditSettingsModel(editSettingsModelType: .effect, sections: newTextSections)
        self.editSettingsModel = newTextSettingsModel
        self.reloadData()
    }
    
    func addPixelSetting(editSettingsModel: EditSettingsModel) {
        guard editSettingsModel.editSettingsModelType == .effect else { return }
        self.editSettingsModel = editSettingsModel
        self.reloadData()
    }
    
    func returnTextSettingsModel(editSettingsModel: EditSettingsModel) {
        guard editSettingsModel.editSettingsModelType == .text else { return }
        self.editSettingsModel = editSettingsModel
        self.reloadData()
    }
    
    
    
    func lockCollectionUI() {
        print("🟣",self.contentSize.height)
        lockingOverlayView.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.contentSize.height + 44)
        self.insertSubview(lockingOverlayView, aboveSubview: self)
        self.bringSubviewToFront(lockingOverlayView)
    }
    
    func unlockCollectionUI() {
        print("🟣",self.frame)
        lockingOverlayView.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height)
        lockingOverlayView.removeFromSuperview()
    }
    
    
}



class LockingOverlayView: UIView {
    
    private let icon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = false
        let configImage = UIImage(systemName: "lock.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 44, weight: .regular))
        iv.image = configImage
        iv.tintColor = AppColors.gray1
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Style
        self.backgroundColor = AppColors.gray6.withAlphaComponent(0.8)
        //
        self.addSubview(icon)
        NSLayoutConstraint.activate([
            icon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            icon.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
