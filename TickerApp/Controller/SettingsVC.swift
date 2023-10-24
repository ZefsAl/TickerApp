//
//  SettingsVC.swift
//  TickerApp
//
//  Created by Serj on 17.10.2023.
//

import UIKit

//protocol SettingsVCDelegate {
//    var viewController: SettingsVC { get set }
//}


final class SettingsVC: UIViewController, SettingsVCDelegate {
    
    var viewController: SettingsVC?
    let viewModel = AppSettingsVM()
    

    // MARK: - Settings CV
    let settingsCV: RegularCollectionView = {
        let cv = RegularCollectionView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isScrollEnabled = true
        cv.alwaysBounceVertical = true
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For remote open
        viewModel.delegateVC = self
        self.viewController = self
        // setup
        configureNAV()
        setSettingsCV()
        setupUI()
        
    }
    
    // MARK: - configure NAV
    private func configureNAV() {
        self.view.backgroundColor = .black
        self.title = "Settings"
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.setCloseButton(color: AppColors.secondary, selector: #selector(closeAct))
    }
    // MARK: - closeAct
    @objc private func closeAct(_ sender: MediumButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    // MARK: - setSettingsCV
    private func setSettingsCV() {
        settingsCV.delegate = self
        settingsCV.dataSource = self
        // register
        settingsCV.register(AppSettingsCVCell.self, forCellWithReuseIdentifier: AppSettingsCVCell.reuseID)
        settingsCV.register(PromoCVCell.self, forCellWithReuseIdentifier: PromoCVCell.reuseID)
    }
    
    

}


// MARK: - Setup UI
extension SettingsVC {
    private func setupUI() {
        
        self.view.addSubview(settingsCV)
        
        let viewMargin = self.view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            
            settingsCV.topAnchor.constraint(equalTo: viewMargin.topAnchor, constant: 24),
            settingsCV.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            settingsCV.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            settingsCV.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            
        ])
    }
     
}




// MARK: - Delegate
extension SettingsVC: UICollectionViewDelegate, PromoCVCellDelegate {
    
    // Promo cell Action
    func showPaywall() {
        let navVC = UINavigationController(rootViewController: PaywallVC())
        navVC.modalPresentationStyle = .overFullScreen
        self.present(navVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        if indexPath.row == 0 {
//            let navVC = UINavigationController(rootViewController: PaywallVC())
//            navVC.modalPresentationStyle = .overFullScreen
//            self.present(navVC, animated: true)
//        }
        viewModel.settingsCells[indexPath.row].handler()
    }
}

// MARK: - DataSource
extension SettingsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
//        if section == 1 {
//            return viewModel.settingsCells.count
//        } else {
//            return 1
//        }
        
        return viewModel.settingsCells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        

        
        
        
        let model = self.viewModel.settingsCells[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppSettingsCVCell.reuseID, for: indexPath) as? AppSettingsCVCell
        
        let bigCell = collectionView.dequeueReusableCell(withReuseIdentifier: PromoCVCell.reuseID, for: indexPath) as? PromoCVCell
        
        if indexPath.row == 0 {
            bigCell?.promoCVCellDelegate = self
            return bigCell ?? UICollectionViewCell()
        } else {
            cell?.configure(title: model.title, leftIcon: model.iconSystemName)
            return cell ?? UICollectionViewCell()
        }
        
        
//        return cell ?? UICollectionViewCell()
    }
}

// MARK: - FlowLayout
extension SettingsVC: UICollectionViewDelegateFlowLayout {
    // Cell Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let spacing: CGFloat = 32 // |16 16|
        if indexPath.row == 0 {
            return CGSize(width: (collectionView.frame.size.width)-spacing, height: 248)
        }
        return CGSize(width: (collectionView.frame.size.width)-spacing, height: 64)
    }
    
    // Vertical spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
}
