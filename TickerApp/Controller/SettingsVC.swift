//
//  SettingsVC.swift
//  TickerApp
//
//  Created by Serj on 17.10.2023.
//

import UIKit

final class SettingsVC: UIViewController {

    // MARK: - Settings CV
    let settingsCV: RegularCollectionView = {
        let cv = RegularCollectionView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isScrollEnabled = true
        cv.alwaysBounceVertical = true 
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNAV()
        setSettingsCV()
        setupUI()
    }
    
    // MARK: - configure NAV
    private func configureNAV() {
        self.view.backgroundColor = .orange
        self.title = "Settings"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: SFProRounded.set(fontSize: 24, weight: .heavy)
        ]
    }
    
    // MARK: - setSettingsCV
    private func setSettingsCV() {
        settingsCV.delegate = self
        settingsCV.dataSource = self
        // register
        settingsCV.register(AppSettingsCVCell.self, forCellWithReuseIdentifier: AppSettingsCVCell.reuseID)
    }
    
    

}


// MARK: - Setup UI
extension SettingsVC {
    private func setupUI() {
        
        
        self.view.addSubview(settingsCV)
        
        let viewMargin = self.view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            
            settingsCV.topAnchor.constraint(equalTo: viewMargin.topAnchor, constant: 0),
            settingsCV.leadingAnchor.constraint(equalTo: viewMargin.leadingAnchor, constant: 0),
            settingsCV.trailingAnchor.constraint(equalTo: viewMargin.trailingAnchor, constant: 0),
            settingsCV.bottomAnchor.constraint(equalTo: viewMargin.bottomAnchor, constant: 0),
            
        ])
    }
     
}




// MARK: - Delegate
extension SettingsVC: UICollectionViewDelegate {
    
}

// MARK: - DataSource
extension SettingsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppSettingsCVCell.reuseID, for: indexPath) as? AppSettingsCVCell
        cell?.configure(title: "Setting", leftIcon: "exclamationmark.circle.fill")
        
        return cell ?? UICollectionViewCell()
    }
}

// MARK: - FlowLayout
extension SettingsVC: UICollectionViewDelegateFlowLayout {
    // Cell Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: (collectionView.frame.size.width), height: 64)
    }
    
    // Vertical spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
