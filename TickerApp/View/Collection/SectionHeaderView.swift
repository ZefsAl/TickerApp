//
//  SectionHeaderView.swift
//  TickerApp
//
//  Created by Serj on 05.10.2023.
//

import Foundation
import UIKit


final class SectionHeaderView: UICollectionReusableView {
    
    static var reuseID: String {
        String(describing: self)
    }
    
    var label: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = AppColors.gray2
        l.font = SFProRounded.set(fontSize: 17, weight: .heavy)
        l.sizeToFit()
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

