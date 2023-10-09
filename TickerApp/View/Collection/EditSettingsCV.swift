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
    
    let editSettingsVM: EditSettingsVM
    
    var selectedSettings: [IndexPath] = [] {
        didSet {
            print("selectedSettings == \(self.indexPathsForSelectedItems)")
            
        }
    }
    
    // MARK: - init
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, editSettingsVM: EditSettingsVM) {
        
        self.editSettingsVM = editSettingsVM
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
            
            let section = self.editSettingsVM.effectSettings[sectionIndex]
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
        return editSettingsVM.effectSettings.count
    }
    
    // MARK: - Items In Section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        editSettingsVM.effectSettings[section].sectionCells.count
        
    }
    
    // MARK: - cell For Item At
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellData = editSettingsVM.effectSettings[indexPath.section].sectionCells[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditSettingCVCell.reuseID, for: indexPath) as? EditSettingCVCell
        
        switch cellData.self {
        case .regularCell(let model):
            cell?.configure(title: model.title, iconSystemName: model.iconSystemName, onlyBGColor: nil)
            return cell ?? UICollectionViewCell()
        }
        
        
    }
    
    // MARK: - Supplementary Element
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let title = editSettingsVM.effectSettings[indexPath.section].sectionTitle
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseID, for: indexPath) as? SectionHeaderView
        sectionHeader?.label.text = title
        sectionHeader?.label.font = SFProRounded.set(fontSize: 14, weight: .semibold)
        return sectionHeader ?? UICollectionReusableView()
    }
    
}


// MARK: - Delegate
extension EditSettingsCV: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // MARK: - v1 Select only one row in section
        if let selectedIndexPaths = collectionView.indexPathsForSelectedItems {
            // Суть в том что бы на выходе не иметь одинаковых одинаковых строк в секции
            for selectedIndex in selectedIndexPaths {
                if (indexPath.section == selectedIndex.section) && (indexPath.row != selectedIndex.row) {
                    collectionView.deselectItem(at: selectedIndex, animated: true) // только при переключении
                }
            }
        } // selectedSettings = selectedIndexPaths // хранит предыдущий индекс!
        if let selectedIndexPaths = collectionView.indexPathsForSelectedItems {
            selectedSettings = selectedIndexPaths
        }
    }
}


