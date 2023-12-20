//
//  EditSettingCVCell.swift
//  TickerApp
//
//  Created by Serj on 07.10.2023.
//

import UIKit


final class EditSettingCVCell: UICollectionViewCell {
    
    static var reuseID: String {
        String(describing: self)
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.icon.tintColor = .white
                self.title.textColor = .white
                self.backgroundColor = .black
                bgContent.layer.borderColor = AppColors.primary.cgColor
            } else {
                disableState()
            }
        }
    }
    
    // MARK: - PremiumBageView
    private let premiumBadgeView: PremiumBadgeView = {
       let v = PremiumBadgeView()
        v.isHidden = true
        return v
    }()
    
    // MARK: - title
    private let title: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = SFProRounded.set(fontSize: 17, weight: .heavy)
        l.textAlignment = .left
        return l
    }()
    
    // MARK: - icon
    private let icon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = false
        return iv
    }()
    
    // MARK: - BG Color
    private let bgContent: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        // Перенес border сюда
        iv.layer.borderWidth = 3
        iv.layer.cornerRadius = 14
        iv.clipsToBounds = true
        return iv
    }()
    
    // MARK: - init ⚙️
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Default state
        disableState()
        // Style
        self.layer.cornerRadius = 14
        self.clipsToBounds = false
        // Setup
        setupStack()
        
    }
    
    // MARK: - disable State
    private func disableState() {
        self.backgroundColor = AppColors.gray6
        self.icon.tintColor = AppColors.gray2
        self.title.textColor = AppColors.gray2
        bgContent.layer.borderColor = UIColor.clear.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure ⚙️
    func configure(model: RegularCellModel) {
        // title
        self.title.text = model.title ?? nil // <--- переделать все в таком виде 
        
        // font Name
        if let fontName = model.fontName {
            self.title.font = UIFont(name: fontName, size: 25)
        } else {
            self.title.font = SFProRounded.set(fontSize: 17, weight: .heavy)
        }
        // icon
        if let iconSystemName = model.iconSystemName {
            let configImage = UIImage(systemName: iconSystemName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold))
            self.icon.image = configImage
        } else {
            self.icon.image = nil
        }
        // BG
        if let bgColor = model.bgColor {
            self.bgContent.backgroundColor = bgColor
        } else {
            self.bgContent.backgroundColor = .clear
        }
        // bg Image
        if let bgImageName = model.bgImageName {
            self.bgContent.image = UIImage(named: bgImageName)
        } else {
            self.bgContent.image = nil
        }
        showPremiumBadge(isPremium: model.isPremium)
    }
    
    private func showPremiumBadge(isPremium: Bool) {
        if isPremium {
            self.premiumBadgeView.isHidden = false
        } else {
            self.premiumBadgeView.isHidden = true
        }
    }
    
    //
    func hideTitle() {
        self.title.isHidden = true
    }
    
    
    // MARK: - Set up Stack
    private func setupStack() {
        
        let contentStack = UIStackView(arrangedSubviews: [title,icon])
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .horizontal
        contentStack.alignment = .center
        contentStack.spacing = 0
        
        
        self.addSubview(contentStack)
        self.addSubview(bgContent)
        self.addSubview(premiumBadgeView)
        
        NSLayoutConstraint.activate([
            
            premiumBadgeView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 4),
            premiumBadgeView.topAnchor.constraint(equalTo: self.topAnchor, constant: -6),
            
            contentStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            bgContent.topAnchor.constraint(equalTo: self.topAnchor),
            bgContent.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bgContent.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bgContent.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
        ])
    }
}




