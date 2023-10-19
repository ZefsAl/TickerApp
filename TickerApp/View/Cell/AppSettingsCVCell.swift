//
//  AppSettingsCVCell.swift
//  TickerApp
//
//  Created by Serj on 17.10.2023.
//

import UIKit

final class AppSettingsCVCell: UICollectionViewCell {
    
    static var reuseID: String {
        String(describing: self)
    }
    
    // MARK: - title
    private let title: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = SFProRounded.set(fontSize: 17, weight: .heavy)
        l.textAlignment = .left
        l.textColor = #colorLiteral(red: 0.1882352941, green: 0.8588235294, blue: 0.3568627451, alpha: 1)
        
        return l
    }()
    
    // MARK: - icon
    private let leftIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = #colorLiteral(red: 0.1882352941, green: 0.8588235294, blue: 0.3568627451, alpha: 1)
        iv.isUserInteractionEnabled = false
        return iv
    }()
    // MARK: - icon
    private let rightIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = #colorLiteral(red: 0.1882352941, green: 0.8588235294, blue: 0.3568627451, alpha: 1)
        iv.isUserInteractionEnabled = false
        
        let icon = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold))
        iv.image = icon
        
        return iv
    }()
    
    
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Style
        self.backgroundColor = AppColors.gray6
        // Border
        self.layer.cornerRadius = 26
        // Setup
        setupStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    func configure(title: String, leftIcon: String) {
        // title
        self.title.text = title
        // image
        let leftIcon = UIImage(systemName: leftIcon, withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold))
        
        self.leftIcon.image = leftIcon
    }
    
    
    // MARK: - Set up Stack
    private func setupStack() {
        
        let contentStack = UIStackView(arrangedSubviews: [leftIcon,title,UIView(),rightIcon])
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .horizontal
        contentStack.alignment = .fill
        contentStack.spacing = 6
        
        self.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            
            
            contentStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            contentStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            contentStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
//            contentStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            
        ])
    }
}

