//
//  TickerCVCell.swift
//  TickerApp
//
//  Created by Serj on 05.10.2023.
//

import UIKit

final class TickerCVCell: UICollectionViewCell {
    
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
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Border
        self.layer.cornerRadius = 26
        self.layer.borderWidth = 3
        self.layer.borderColor = AppColors.gray6.cgColor
        // Setup
        setupStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Configure
    func configure(title: String) {
        // Cell Style
        self.backgroundColor = .clear
        
        self.title.text = title
    }
    
    
    // MARK: - Set up Stack
    private func setupStack() {
        
        let contentStack = UIStackView(arrangedSubviews: [title])
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

