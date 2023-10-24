//
//  BigButton.swift
//  TickerApp
//
//  Created by Serj on 05.10.2023.
//

import UIKit

final class BigButton: UIButton {

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
        return iv
    }()
    
    // MARK: - AIV
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.contentMode = .scaleAspectFit
        aiv.color = AppColors.secondary
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    
    // MARK: - Init
    init(frame: CGRect, bgColor: UIColor, title: String?, titleColor: UIColor?, iconSystemName: String?, iconColor: UIColor?) {
        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 30
        self.backgroundColor = bgColor

        // title
        self.title.text = title
        self.title.textColor = titleColor
        // icon
        let configImage = UIImage(systemName: iconSystemName ?? "", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold))
        icon.image = configImage
        icon.tintColor = iconColor

        setupUI()
    }
    
    
    
    
    // MARK: - UI
    private func setupUI() {
        
        let contentStack = UIStackView(arrangedSubviews: [icon,title,activityIndicatorView])
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .horizontal
        contentStack.alignment = .center
        contentStack.spacing = 6
        contentStack.isUserInteractionEnabled = false
        
        self.addSubview(contentStack)
        NSLayoutConstraint.activate([

            contentStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            contentStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.heightAnchor.constraint(equalToConstant: 60),

        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

