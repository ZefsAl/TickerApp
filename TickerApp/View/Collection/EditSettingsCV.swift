//
//  EditSettingsCV.swift
//  TickerApp
//
//  Created by Serj on 06.10.2023.
//

import UIKit

final class EditSettingsCV: UICollectionView {

    let editSettingsModel: EditSettingsModel

    
    var selectedEffectIndexPath: [IndexPath] = [] {
        didSet {
            print("Effect Settings == \(selectedEffectIndexPath)")
        }
    }
    
    var selectedTextIndexPath: [IndexPath] = [] {
        didSet {
            print("Text Settings == \(selectedTextIndexPath)")
            
        }
    }
    var selectedBackgroundIndexPath: [IndexPath] = [] {
        didSet {
            print("Backgroun Settings == \(selectedBackgroundIndexPath)")
        }
    }
    
    
    
    
    
    
    
    
    
    // MARK: - init
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, editSettingsModel: EditSettingsModel) {
        
        self.editSettingsModel = editSettingsModel
        super.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        setupCell()
        
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
    // headerItem + used Delegate
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
    private func setupCell() {
        self.delegate = self
        self.dataSource = self
        // Header
        self.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseID)
        // Cell
        self.register(EditSettingCVCell.self, forCellWithReuseIdentifier: EditSettingCVCell.reuseID)
        //
        self.allowsMultipleSelection = true
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
        
        let cellData = self.editSettingsModel.sections[indexPath.section].sectionCells[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditSettingCVCell.reuseID, for: indexPath) as? EditSettingCVCell
        
        switch cellData.self {
        case .regularCell(let model):
            cell?.configure(
                title: model.title,
                iconSystemName: model.iconSystemName,
                onlyBGColor: model.bgColor,
                fontName: model.fontName
            )
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
    
    func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
      guard let indexPaths = collectionView.indexPathsForSelectedItems else { return true }
      return indexPaths.isEmpty
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Select only one row in section
        if let selectedIndexPaths = collectionView.indexPathsForSelectedItems {
            // Суть в том что бы на выходе не иметь одинаковых одинаковых строк в секции
            for selectedIndex in selectedIndexPaths {
                if (indexPath.section == selectedIndex.section) && (indexPath.row != selectedIndex.row) {
                    collectionView.deselectItem(at: selectedIndex, animated: true) // только при переключении
                }
            }
        }
        
        // set Settings
        
        //  Effect
        if editSettingsModel.editSettingsModelType == .effect {
            guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems else { return }
            selectedEffectIndexPath = selectedIndexPaths
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
            
        }
        
    }
    
    // MARK: - get Selected Settings v1
    func getSelectedSettingss(selectedSettings: [IndexPath], handler: @escaping (RegularCell) -> Void ) {
        for selectedIndex in selectedSettings {
            // Сопоставляем выбранные selectedIndex с editSettingsModel
            let cellData = editSettingsModel.sections[selectedIndex.section].sectionCells[selectedIndex.row]
            // Используем как RegularCell - model
            switch cellData.self {
            case .regularCell(let model):
                // Получаем данные и присваиваем - model.bgColor
                handler(model)
            }
        }
    }
    
    // MARK: - get Selected Settings v2
    func getSelectedSettings_v2(selectedSettings: [IndexPath], compareWith: String, handler: @escaping (RegularCell) -> Void ) {
        
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


