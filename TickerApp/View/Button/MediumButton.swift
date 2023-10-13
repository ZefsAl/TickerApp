//
//  MediumButton.swift
//  TickerApp
//
//  Created by Serj on 05.10.2023.
//

import UIKit

final class MediumButton: UIButton {
    
    // MARK: - title
    private let title: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.isUserInteractionEnabled = false
        l.textColor = .white
        l.font = SFProRounded.set(fontSize: 17, weight: .heavy)
        return l
    }()
    
    // MARK: - Icon
    let icon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = false
        
        iv.contentMode = .scaleAspectFit
        iv.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return iv
    }()
    
    
    // MARK: - Init
    init(
        frame: CGRect,
        bgColor: UIColor,
        title: String?,
        titleColor: UIColor?,
        iconSystemName: String?,
        iconColor: UIColor?,
        hideTitle: Bool) {
            super.init(frame: frame)
            
            self.translatesAutoresizingMaskIntoConstraints = false
            self.layer.cornerRadius = 25
            self.backgroundColor = bgColor
            
            // title
            
            self.title.text = title
            self.title.textColor = titleColor
            
            if hideTitle {
                self.title.isHidden = true
            }
            
            
            // icon
            let configImage = UIImage(systemName: iconSystemName ?? "", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold))
            icon.image = configImage
            icon.tintColor = iconColor
            
            setupUI()
        }
    
    
    
    
    // MARK: - UI
    private func setupUI() {
        
        let contentStack = UIStackView(arrangedSubviews: [icon,title])
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .horizontal
        contentStack.alignment = .center
        contentStack.spacing = 6
        contentStack.isUserInteractionEnabled = false
        
        self.addSubview(contentStack)
        NSLayoutConstraint.activate([
            
            contentStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            contentStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            contentStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            self.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

