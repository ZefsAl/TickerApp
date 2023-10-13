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
                self.layer.borderColor = AppColors.primary.cgColor
//                v.backgroundColor = .clear
            } else {
                
                disableState()
                
            }
        }
    }
    
    // MARK: - title
    private let title: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = SFProRounded.set(fontSize: 17, weight: .heavy)
        l.textAlignment = .left
//        l.textColor = #colorLiteral(red: 0.1882352941, green: 0.8588235294, blue: 0.3568627451, alpha: 1)
        
        return l
    }()
    
    // MARK: - icon
    private let icon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.tintColor = #colorLiteral(red: 0.1882352941, green: 0.8588235294, blue: 0.3568627451, alpha: 1)
        iv.isUserInteractionEnabled = false
        return iv
    }()
    
    let onlyBGColor: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
//        v.backgroundColor = .clear
        return v
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Default state
        self.backgroundColor = AppColors.gray6
        disableState()
        // Style
        self.layer.borderWidth = 3
        self.layer.cornerRadius = 14
        self.clipsToBounds = true
        // Setup
        setupStack()
    }
    // MARK: - disable State
    private func disableState() {
        self.backgroundColor = AppColors.gray6
        self.icon.tintColor = AppColors.gray2
        self.title.textColor = AppColors.gray2
        self.layer.borderColor = UIColor.clear.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    func configure(title: String?, iconSystemName: String?, onlyBGColor: UIColor?, fontName: String?) {
        // title
        if title != nil {
            self.title.text = title
        }
        // MARK: - fontName
        if fontName != nil {
            self.title.font = UIFont(name: fontName ?? "", size: 25)
            
        }
        // image
        if iconSystemName != nil {
            let configImage = UIImage(systemName: iconSystemName ?? "", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold))
            self.icon.image = configImage
        }
        // BG
        if onlyBGColor != nil {
            
            self.onlyBGColor.backgroundColor = onlyBGColor
        }
        
        
    }
    
    
    // MARK: - Set up Stack
    private func setupStack() {
        
        let contentStack = UIStackView(arrangedSubviews: [title,icon])
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .horizontal
        contentStack.alignment = .center
        contentStack.spacing = 0
        
        self.addSubview(contentStack)
        
        self.addSubview(onlyBGColor)
        
        NSLayoutConstraint.activate([
            contentStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            
            onlyBGColor.topAnchor.constraint(equalTo: self.topAnchor),
            onlyBGColor.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            onlyBGColor.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            onlyBGColor.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
        ])
    }
}

