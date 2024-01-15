//
//  SettingsVC.swift
//  TickerApp
//
//  Created by Serj on 17.10.2023.
//

import UIKit

final class SettingsVC: UIViewController, SettingsVCDelegate {
    
    var settingsVC: SettingsVC?
    private let viewModel = AppSettingsVM()
    
    // MARK: - Settings CV
    private let settingsCV: RegularCollectionView = {
        let cv = RegularCollectionView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isScrollEnabled = true
        cv.alwaysBounceVertical = true
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    // MARK: - view Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Delegate
        viewModel.delegateVC = self
        self.settingsVC = self
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
        settingsCV.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        let viewMargin = self.view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            settingsCV.topAnchor.constraint(equalTo: viewMargin.topAnchor, constant: 0),
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
        
        UIView().hapticImpact(style: .soft)
        
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.isUserInteractionEnabled = true
        cell?.colorAnimateTap()
        
        viewModel.settingsCells[indexPath.row].handler()
    }
}

// MARK: - DataSource
extension SettingsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.settingsCells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model = self.viewModel.settingsCells[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppSettingsCVCell.reuseID, for: indexPath) as? AppSettingsCVCell
        
        let bigCell = collectionView.dequeueReusableCell(withReuseIdentifier: PromoCVCell.reuseID, for: indexPath) as? PromoCVCell
        
        if indexPath.row == 0 {
            let bool = UserDefaults.standard.object(forKey: "UserIsPremiumObserverKey") as! Bool
            bigCell?.isHidden = bool
            bigCell?.promoCVCellDelegate = self
            return bigCell ?? UICollectionViewCell()
        } else {
            cell?.configure(title: model.title, leftIcon: model.iconSystemName)
            return cell ?? UICollectionViewCell()
        }
        
    }
}

// MARK: - FlowLayout
extension SettingsVC: UICollectionViewDelegateFlowLayout {
    // Cell Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let spacing: CGFloat = 32 // |16  16|
        let bool = UserDefaults.standard.object(forKey: "UserIsPremiumObserverKey") as! Bool
        
        if indexPath.row == 0 {
            return CGSize(width: (collectionView.frame.size.width)-spacing,
                          height: bool ? 0 : 248
            )
        }
        return CGSize(width: (collectionView.frame.size.width)-spacing, height: 64)
    }
    
    // Vertical spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
}



