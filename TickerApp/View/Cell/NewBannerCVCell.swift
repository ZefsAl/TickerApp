//
//  NewBannerCVCell.swift
//  TickerApp
//
//  Created by Serj on 03.10.2023.
//

import UIKit

final class NewBannerCVCell: UICollectionViewCell {
    
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
    private let icon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = #colorLiteral(red: 0.1882352941, green: 0.8588235294, blue: 0.3568627451, alpha: 1)
        iv.isUserInteractionEnabled = false
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
    func configure(title: String, iconSystemName: String) {
        // title
        self.title.text = title
        // image
        let configImage = UIImage(systemName: iconSystemName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold))
        self.icon.image = configImage
        
    }
    
    
    // MARK: - Set up Stack
    private func setupStack() {
        
        let contentStack = UIStackView(arrangedSubviews: [title,icon])
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .horizontal
        contentStack.alignment = .center
        contentStack.spacing = 6
        
        self.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            contentStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            contentStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            contentStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
        ])
    }
}

