//
//  CircleButton.swift
//  TickerApp
//
//  Created by Serj on 05.10.2023.
//

import UIKit

final class CircleButton: UIButton {
    
    // MARK: - Icon
    let icon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = false

        return iv
    }()
    
    
    // MARK: - Init
    init(frame: CGRect, bgColor: UIColor, iconSystemName: String, iconColor: UIColor) {
        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 25
        self.backgroundColor = bgColor

        // icon
        let configImage = UIImage(systemName: iconSystemName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .bold))
        icon.image = configImage
        icon.tintColor = iconColor
        
        setupUI()
    }
    
    
    
    
    // MARK: - UI
    private func setupUI() {
        
        let contentStack = UIStackView(arrangedSubviews: [icon])
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .horizontal
        contentStack.alignment = .center
//        contentStack.spacing = 6
        contentStack.isUserInteractionEnabled = false
        
        self.addSubview(contentStack)
        NSLayoutConstraint.activate([

            contentStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            contentStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            self.heightAnchor.constraint(equalToConstant: 50),
            self.widthAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

