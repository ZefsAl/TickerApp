//
//  EditSettingsCV.swift
//  TickerApp
//
//  Created by Serj on 06.10.2023.
//

import UIKit

// invalidateIntrinsicContentSize
//
final class EditSettingsCV: UICollectionView {
    
    let editSettingsModel: EditSettingsModel
    
    var selectedEffectSettings: [IndexPath] = [] {
        didSet {
            print("Effect Settings == \(selectedEffectSettings)")
        }
    }
    
    var selectedTextSettings: [IndexPath] = [] {
        didSet {
            print("Text Settings == \(selectedTextSettings)")
            
        }
    }
    var selectedBackgrounSettings: [IndexPath] = [] {
        didSet {
            print("Backgroun Settings == \(selectedBackgrounSettings)")
        }
    }
    
    
    // Можем ссылаться на TickerVIew в VM
    
    
    
    
    
    
    // MARK: - init
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, editSettingsModel: EditSettingsModel) {
        
        self.editSettingsModel = editSettingsModel
        super.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        //        self.translatesAutoresizingMaskIntoConstraints = false
        setupCell()
        
        self.backgroundColor = .clear
        self.alwaysBounceVertical = true
        
        
        setupLayoutCV()
        
    }
    
    required init?(coder: NSCoder) {
        //        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Layout
    private func setupLayoutCV() {
        // Compositional Layout
        let collectionViewLayout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, environment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            //            let section = self.editSettingsVM.effectSettings[sectionIndex]
            //            let section = self.editSettingsSection[sectionIndex]
            let section = self.editSettingsModel.sections[sectionIndex]
            
            // Должны вернуть NSCollectionLayoutSection для конкретной секции
            return self.setSectionLayout(sectionItems: section.sectionCells, environment: environment)
        }
        // Collection View
        self.collectionViewLayout = collectionViewLayout
    }
    
    private func setSectionLayout(sectionItems: [CellSectionType], environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        // layout Item + Size
        // let contentSize = environment.container.contentSize
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
    // headerItem + Delegate
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
        //        return editSettingsVM.effectSettings.count
        //        return editSettingsSection.count
        return self.editSettingsModel.sections.count
    }
    
    // Items In Section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //        editSettingsVM.effectSettings[section].sectionCells.count
        //        return editSettingsSection[section].sectionCells.count
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


// MARK: - Delegate UICollectionView
extension EditSettingsCV: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // - v1 Select only one row in section
        if let selectedIndexPaths = collectionView.indexPathsForSelectedItems {
            // Суть в том что бы на выходе не иметь одинаковых одинаковых строк в секции
            for selectedIndex in selectedIndexPaths {
                if (indexPath.section == selectedIndex.section) && (indexPath.row != selectedIndex.row) {
                    collectionView.deselectItem(at: selectedIndex, animated: true) // только при переключении
                }
            }
        }
        
        
        
        // MARK: - Effect Settings
        if editSettingsModel.editSettingsModelType == .effect {
            guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems else { return }
            selectedEffectSettings = selectedIndexPaths
            
            getSelectedSettings(selectedSettings: selectedEffectSettings) { model in
                EditSettingsVM.tickerView.setEffect(speedStr: model.title)
            }
        }
        
        
        // MARK: - Text Settings
        // Добавляем выбранные indexPathsForSelectedItems в отдельный массив
        if editSettingsModel.editSettingsModelType == .text {
            guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems else { return }
            selectedTextSettings = selectedIndexPaths
            // Применяем Text select
            
            // MARK: - Size
            getSelectedSettings_v2(selectedSettings: selectedTextSettings, compareWith: "Size") { model in
                EditSettingsVM.tickerView.setFontSize(stringSize: model.title)
            }

            // MARK: - Font
            getSelectedSettings_v2(selectedSettings: selectedTextSettings, compareWith: "Fonts") { model in
                if let fontName = model.fontName {
                    EditSettingsVM.tickerView.setFont(fontName: fontName)
                }
            }
            
            // MARK: - Color
            getSelectedSettings_v2(selectedSettings: selectedTextSettings, compareWith: "Color") { model in
                EditSettingsVM.tickerView.setText(textColor: model.bgColor)
            }
            
            
        }
        
        // MARK: - Effect Settings
        if editSettingsModel.editSettingsModelType == .background {
            guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems else { return }
            selectedBackgrounSettings = selectedIndexPaths
            
            getSelectedSettings(selectedSettings: selectedBackgrounSettings) { model in
                EditSettingsVM.tickerView.setBackground(background: model.bgColor)
            }
        }
        
    }
    
    // MARK: - get Selected Settings v1
    func getSelectedSettings(selectedSettings: [IndexPath], handler: @escaping (RegularCell) -> Void ) {
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


