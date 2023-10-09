//
//  HomeCVC.swift
//  TickerApp
//
//  Created by Serj on 03.10.2023.
//

import UIKit

final class HomeCollectionView: UICollectionView {
    
    private let someArr = ["one", "two", "three", "four", "five"]
    
    // MARK: - init by invalidate Intrinsic Content Size
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        commonInit()
        setupCell()
        
        self.backgroundColor = .clear
        self.isScrollEnabled = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        isScrollEnabled = false
    }
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    
    // MARK: - Setup Cell
    private func setupCell() {
        self.delegate = self
        self.dataSource = self
        // Header
        self.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseID)
        // Cell
        self.register(NewBannerCVCell.self, forCellWithReuseIdentifier: NewBannerCVCell.reuseID)
        self.register(TickerCVCell.self, forCellWithReuseIdentifier: TickerCVCell.reuseID)
    }
    
    
}



// MARK: - Data Source
extension HomeCollectionView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    // MARK: - ItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else {
            return someArr.count
        }
        
    }
    
    // MARK: - cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewBannerCVCell.reuseID, for: indexPath) as? NewBannerCVCell
            cell?.configure(title: "New Banner", iconSystemName: "plus.circle.fill")
            return cell ?? UICollectionViewCell()
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TickerCVCell.reuseID, for: indexPath) as? TickerCVCell
        cell?.configure(title: someArr[indexPath.row])
        return cell ?? UICollectionViewCell()
    }
    
    // MARK: - Supplementary Element
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        

        
//        if indexPath.section == 0 {
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseID, for: indexPath) as? SectionHeaderView
            sectionHeader?.label.text = "Recent"
            return sectionHeader ?? UICollectionReusableView()
//        }
        
//        return UICollectionReusableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        
//        if indexPath.section == 1 {
//            guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
//            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? SectionHeaderView
//            sectionHeader?.label.text = "Recent"
//            return sectionHeader ?? UICollectionReusableView()
//        }
        
        
        
        
             
//            if indexPath.section == 1 {
//                let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? SectionHeaderView
//                sectionHeader?.label.text = "Recent"
//                return sectionHeader ?? UICollectionReusableView()
//            } else {
//                return UICollectionReusableView()
//            }
            
            
            
        
    }
    
    // MARK: - Header In Section
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 1 {
            return CGSize(width: collectionView.frame.width, height: 44)
        }
        
        return CGSize(width: 0, height: 0)
    }
}

// MARK: - Delegate
extension HomeCollectionView: UICollectionViewDelegate {
    
}

// MARK: - Flow Layout
extension HomeCollectionView: UICollectionViewDelegateFlowLayout {
    // Cell Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: (collectionView.frame.size.width), height: 100)
        } else {
            return CGSize(width: (collectionView.frame.size.width), height: 160)
        }
    }
    
    
    // Vertical spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}



