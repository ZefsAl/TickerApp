//
//  HomeVC.swift
//  TickerApp
//
//  Created by Serj on 03.10.2023.
//

import UIKit
import RealmSwift
import ApphudSDK

final class HomeVC: UIViewController {
    
    // MARK: - Realm
    let realm = try! Realm()
    var notificationToken: NotificationToken?
    
    
    // MARK: - CollectionView
    private let homeCollectionView = RegularCollectionView()
    
    
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
        b.addTarget(Any?.self, action: #selector(ctaAct), for: .touchUpInside)
        return b
    }()
    @objc private func ctaAct() {
        let navVC = UINavigationController(rootViewController: PaywallVC())
        navVC.modalPresentationStyle = .overFullScreen
        self.present(navVC, animated: true)
    }
    
    
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
        
        self.title = "LED Ultra"
        // Setup
        setSettingNavButtonItem(selectorStr: #selector(self.settingsAct))
        self.view.backgroundColor = .black
        setupUI()
        // Delegate
        setupCollectionView()
        
        setTickerObserver()
        
        // test
        let object = UserDefaults.standard.object(forKey: "OnboardingIsCompleted") as? Bool
        if let object = object {
            print("OnboardingIsCompleted ----- ",object)
        }
    }
    
    
//    override func viewDidLayoutSubviews() {
//         super.viewDidLayoutSubviews()
//    }
    
    // MARK: - view Will Appear
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    
    // MARK: - settingsAct
    @objc func settingsAct() {
//        print("ettingsAct")
        self.navigationController?.pushViewController(SettingsVC(), animated: true)
    }
    
    
    
    
    // MARK: - Observer
    private func setTickerObserver() {

        let objects = realm.objects(TickerDataModel.self)
        
        notificationToken = objects.observe() { [weak self] (changes: RealmCollectionChange) in
            
            switch changes {
            case .initial(initial: let initial):
                print("initial", initial.count)
//                self?.homeCollectionView.reloadData()
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                print("Deleted indices: ", deletions)
                print("Inserted indices: ", insertions)
                print("Modified modifications: ", modifications)
                self?.homeCollectionView.reloadData()

            case .error(_):
                print("error realm observing")
            }
            
        }
    }
    
    
    // MARK: - Register
    private func setupCollectionView() {
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        // Header
        homeCollectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseID)
        // Cell
        homeCollectionView.register(NewBannerCVCell.self, forCellWithReuseIdentifier: NewBannerCVCell.reuseID)
        homeCollectionView.register(TickerCVCell.self, forCellWithReuseIdentifier: TickerCVCell.reuseID)
    }
    
    
    
    
    
    
}


// MARK: - Setup UI
extension HomeVC {
    
    // Setup UI
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




// MARK: - Data Source
extension HomeVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    // ItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return realm.objects(TickerDataModel.self).count
        }
    }
    
    // cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewBannerCVCell.reuseID, for: indexPath) as? NewBannerCVCell
            cell?.configure(title: "New Banner", iconSystemName: "plus.circle.fill")
            return cell ?? UICollectionViewCell()
            
        }
        
        
        let tickerDataModel = realm.objects(TickerDataModel.self)
        let model = tickerDataModel[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TickerCVCell.reuseID, for: indexPath) as? TickerCVCell
        cell?.configure(tickerDataModel: model)
        return cell ?? UICollectionViewCell()
        
    }
    
    // Supplementary Element
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseID, for: indexPath) as? SectionHeaderView
        sectionHeader?.label.text = "Recent"
        return sectionHeader ?? UICollectionReusableView()
    }
    
    // Header In Section
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 1 {
            return CGSize(width: collectionView.frame.width, height: 44)
        }
        return CGSize(width: 0, height: 0)
    }
}


// MARK: -  Delegate
extension HomeVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 0
        if indexPath.section == 0 && indexPath.row == 0 {
            self.navigationController?.pushViewController(EditBannerVC(tickerDataModel: nil), animated: true)
        }
        // 1
        guard indexPath.section == 1 else { return }
        let object = realm.objects(TickerDataModel.self)
        let model = object[indexPath.row]
        self.navigationController?.pushViewController(EditBannerVC(tickerDataModel: model), animated: true)
        
    }
}

// MARK: - Flow Layout
extension HomeVC: UICollectionViewDelegateFlowLayout {
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
