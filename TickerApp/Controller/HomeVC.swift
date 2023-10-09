//
//  HomeVC.swift
//  TickerApp
//
//  Created by Serj on 03.10.2023.
//

import UIKit

final class HomeVC: UIViewController {
    
    // MARK: - CollectionView
    private let homeCollectionView = HomeCollectionView()
    // MARK: - ctaButton
    private let ctaButton: BigButton = {
        let b = BigButton(
            frame: .zero,
            bgColor: AppColors.primary,
            title: "Get Pro Plan",
            titleColor: AppColors.secondary,
            iconSystemName: "sparkles",
            iconColor: AppColors.secondary
        )
        return b
    }()
    
    
    // MARK: - Scroll View
    private let contentScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = false
        sv.alwaysBounceVertical = true
        return sv
    }()
    
    // MARK: - view Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSettingNavButtonItem(selectorStr: #selector(self.settingsAct))
        setupVCStyle()
        setupUI()
        
        
    }
    
    // MARK: - Actions
    @objc func settingsAct() {
        print("ettingsAct")
    }
    
    
    
}



extension HomeVC {
    
    // MARK: - Style
    private func setupVCStyle() {
        self.view.backgroundColor = .black
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        
        // Content Stack
        let contentStack = UIStackView(arrangedSubviews: [homeCollectionView])
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.alignment = .fill
        contentStack.spacing = 0
        
        // Subview
        self.view.addSubview(contentScrollView)
        contentScrollView.addSubview(contentStack)
        self.view.addSubview(ctaButton)
        
        // Margin
        let scrollViewMargin = contentScrollView.contentLayoutGuide
        let viewMargin = self.view.layoutMarginsGuide
        // Stack values
        let left: CGFloat = 16
        let right: CGFloat = -16
        let width: CGFloat = right - left
        
        NSLayoutConstraint.activate([
            
            ctaButton.leadingAnchor.constraint(equalTo: viewMargin.leadingAnchor, constant: 0),
            ctaButton.trailingAnchor.constraint(equalTo: viewMargin.trailingAnchor, constant: 0),
            ctaButton.bottomAnchor.constraint(equalTo: viewMargin.bottomAnchor, constant: 0),
            
            contentStack.topAnchor.constraint(equalTo: scrollViewMargin.topAnchor, constant: 32),
            contentStack.leadingAnchor.constraint(equalTo: scrollViewMargin.leadingAnchor, constant: left),
            contentStack.trailingAnchor.constraint(equalTo: scrollViewMargin.trailingAnchor, constant: right),
            contentStack.bottomAnchor.constraint(equalTo: scrollViewMargin.bottomAnchor, constant: -0),
            contentStack.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor, constant: width),
            
            contentScrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            contentScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            contentScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            contentScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
    }
    
    
    
}
